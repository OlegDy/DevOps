#!/usr/bin/env python3

import socket
import time
import datetime

list_hosts = ['drive.google.com', 'mail.google.com', 'google.com']

list_scan = list()

# инициализация данных
for host in list_hosts:
    list_scan.append(list((host, socket.gethostbyname(host))))

while True:
    i = 0
    for pair in list_scan:
        str_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        ip_new = socket.gethostbyname(pair[0])
        ip_old = pair[1]
        if ip_old == ip_new:
            print(str_date+" "+pair[0] + " - " + ip_old)
        else:
            print(str_date+" [ERROR] "+pair[0]+" IP mismatch: "+ip_old+" - "+ip_new)
            list_scan[i] = (pair[0], ip_new)
        i += 1
        time.sleep(0.5)
# endWhile
