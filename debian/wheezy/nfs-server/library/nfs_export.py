#!/usr/bin/python

# NOTE
# This module only recognizes exports formatted as <path> <host>(<opts>). So,
# a line with multiple host descriptors per path will not be recognized correctly.

DOCUMENTATION='''
module: nfs_export
short_description: Export an NFS directory
description: >
 Declare an exported NFS directory using /etc/exports.d. For more details on 
 the meaning of options, consult the exports(5) manpage.
options:
  dest:
    description: The exports configuration file
    required: no
    default: /etc/exports
  path:
    description: The exported directory path
    required: yes
  hostname:
    description: The client's hostname 
    required: yes
  readonly: 
    description: |
      Indicate if path should be exported as readonly. See C(ro) and C(rw) 
      options.
    required: no
    default: no
    type: bool
  secure: 
    description: |
      Indicate if client requests for this path should only originate from
      a privileged (<1024) port. See C(secure) and C(insecure) options.
    required: no
    default: yes
    type: bool
  sync: 
    description: |
      Indicate if requests should be replied only after the changes have
      been committed to stable storage. See C(sync) and C(async) options.
    required: no
    default: yes
    type: bool
  subtree_check: 
    description: |
      Enable or disable subtree checking. See C(subtree_check) option.
    required: no
    default: yes
    type: bool
  squash: 
    description: |
      Describe how and if client requests should be mapped (squased) to local 
      users. See C(root_squash), C(no_root_squash) and C(all_squash) options.
    required: no
    choices: ['none', 'all', 'root']
    default: root
  anon_user:
    description: |
      The anonymous user for squased requests. See C(anonuid) option.
    required: no
  anon_group:
    description: |
      The anonymous group for squased requests. See C(anongid) option.
    required: no
'''

EXAMPLES='''

- nfs_export: path=/var/local/data-1 hostname=somehost.local squash=none readonly=yes

- nfs_export: 
    path: /var/local/backups 
    hostname: tape.local
    sync: yes
    squash: all
    anon_user: backup
    anon_group: backup

'''

import os
import re
import pwd
import grp
import io
from socket import gethostbyname
from collections import OrderedDict
from tempfile import NamedTemporaryFile

from ansible.module_utils.basic import *

def build_export_opts(p):
    
    opts = OrderedDict()
    
    readonly = p.get('readonly')
    if readonly:
        opts['ro'] = None
    else:
        opts['rw'] = None

    secure = p.get('secure')
    if secure:
        opts['secure'] = None
    
    sync = p.get('sync')
    if sync: 
        opts['sync'] = None
    else:
        opts['async'] = None

    subtree_check = p.get('subtree_check')
    if subtree_check:
        opts['subtree_check'] = None
    else:
        opts['no_subtree_check'] = None

    squash = p.get('squash')
    if squash == 'root':
        opts['root_squash'] = None
    elif squash == 'none':
        opts['no_root_squash'] = None
    elif squash == 'all':
        opts['all_squash'] = None
    
    anon_user = p.get('anon_user')
    if anon_user:
        opts['anonuid'] = pwd.getpwnam(anon_user).pw_uid

    anon_group = p.get('anon_group')
    if anon_group:
        opts['anongid'] = grp.getgrnam(anon_group).gr_gid

    return opts

def main():
    module = AnsibleModule(
        argument_spec = dict(
           dest = dict(default='/etc/exports'),
           path = dict(required=True),
           hostname = dict(required=True),
           readonly = dict(type='bool', default=False),
           secure = dict(type='bool', default=True),
           sync = dict(type='bool', default=True),
           subtree_check = dict(type='bool', default=True),
           squash = dict(choices=['none', 'all', 'root'], default='root'),
           anon_user = dict(),
           anon_group = dict()
        ),
        supports_check_mode = True
    )
    p = module.params
    dry_run = module.check_mode

    target_config_file = p.get('dest')

    path = os.path.expanduser(p.get('path').rstrip('/'))
    if not os.path.isdir(path): 
        raise ValueError('The given path %s is not a directory' % (path))

    hostname = p.get('hostname')
    try:
        addr = gethostbyname(hostname)
    except Exception as ex:
        raise ValueError('Cannot resolve the given name (%s)' % (hostname))

    # Build options

    opts = build_export_opts(p)

    # Generate entry suitable for /etc/exports

    export_opts = ['%s=%s' %(k, v) if v else k for k, v in opts.items()]
    line = '%s %s(%s)\n' % (path, hostname, ','.join(export_opts))
    
    # Read target file and replace matching line
    
    if os.path.isfile(target_config_file):
        ifp = open(target_config_file, 'r')
    else:
        ifp = io.StringIO()
    changed = False
    with ifp, NamedTemporaryFile(delete=False) as ofp:
        matched = False
        for line1 in ifp:
            if line1.startswith('#') or re.match('$', line1):
                ofp.write(line1) # copy verbatim
                continue
            path1, rest1 = line1.strip().split()
            if not path == path1.rstrip('/'):
                ofp.write(line1) # copy verbatim
                continue
            m1 = re.match('([\w][-\w\.]+)\(.*\)', rest1)
            assert m1, 'Cannot recognize client spec for %s: %s' % (path1, rest1)
            if hostname == m1.group(1):
                ofp.write(line) # replace match
                matched = True
                changed = (line1 != line)
            else:
                ofp.write(line1) # copy verbatim
        if not matched:
            ofp.write(line) # append line
            changed = True
    
    # Update target 
    
    if not dry_run:
        os.rename(ofp.name, target_config_file)

    module.exit_json(
        changed = changed, 
        path = path,
        hostname = hostname,
        target = target_config_file if not dry_run else ofp.name,
        params = p)

# Go!
main()

