#!/usr/bin/env python3

import os

path_git = "~/netology/sysadm-homeworks"

bash_command = ["cd " + path_git, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
#is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path_git + "/" + prepare_result)




