<?php

// Override settings from config.php

$CONFIG['term'] = array(
    '30min' => 1800,
    '1hour' => 3600, 
) + $CONFIG['term'];

$CONFIG['graph_type'] = 'hybrid';

{% for name in groups.keys()| difference(["all", "ungrouped"]) -%}
$CONFIG['cat']['{{name}}'] = array(
    {% for g in groups[name] -%}
    '{{g}}'{% if not loop.last %},{% endif %}
    {%- endfor -%}
);

{% endfor -%}
