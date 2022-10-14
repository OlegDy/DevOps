#!/usr/bin/env python3

import socket
import time
import datetime
import os
import yaml
import json

list_hosts = ['drive.google.com', 'mail.google.com', 'google.com']

list_scan = []

# инициализация данных
for host in list_hosts:
    list_scan.append({host: socket.gethostbyname(host)})


def save_param(dump):
    with open("host_ip.yaml", "w") as file:
        yaml_str = yaml.dump(dump)
        file.write(yaml_str)
    with open("host_ip.json", "w") as file:
        json_str = json.dumps(dump)
        file.write(json_str)
    return


save_param(list_scan)


while True:
    i = 0
    for pair in list_scan:
        for key in pair.keys():
            str_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            ip_new = socket.gethostbyname(key)
            ip_old = pair[key]
            if ip_old == ip_new:
                print(str_date + " " + key + " - " + ip_old)
            else:
                print(str_date + " [ERROR] " + key + " IP mismatch: " + ip_old + " - " + ip_new)
                list_scan[i] = {str(key): ip_new}
                save_param(list_scan)
            i += 1
            time.sleep(0.2)
    os.system('ipconfig /flushdns > nul')

# endWhile
