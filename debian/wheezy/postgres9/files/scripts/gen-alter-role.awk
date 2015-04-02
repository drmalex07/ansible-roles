BEGIN {
    FS = ":";
    split(users, users_list, /,/);
    for (i in users_list) {
        u = users_list[i]
        users_dict[u] = 1
    }
}

{
    if ($1 in users_dict) {
        printf ("ALTER ROLE \"%s\" PASSWORD $$%s$$\n", $1, $2);
    }
}
