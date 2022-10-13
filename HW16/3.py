#!/usr/bin/env python3

import os
import sys

if len(sys.argv) >= 2:
    path_git = sys.argv[1]
else:
    path_git = os.getcwd()

bash_command = ["cd " + path_git, "git status 2>&1"]
result_os = os.popen(' && '.join(bash_command)).read()
#is_change = False
for result in result_os.split('\n'):
    if result.find('fatal') != -1:
        print("Error - " + result)
        break
    elif result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path_git + "/" + prepare_result)
