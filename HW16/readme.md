# Дамашнее задание 16

## Олег Дьяченко DEVOPS-22

# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1 

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ                                           |
| ------------- |-------------------------------------------------|
| Какое значение будет присвоено переменной `c`?  | выдает ошибку т.к. нельзя напрямую сложить int и str |
| Как получить для переменной `c` значение 12?  | с = str(a)+b                                    |
| Как получить для переменной `c` значение 3?  | c = a + int(b)                                                |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3
import os
bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
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
```

### Вывод скрипта при запуске при тестировании:
```
~/netology/sysadm-homeworks/01-intro-01/README.md
~/netology/sysadm-homeworks/04-script-03-yaml/README.md
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
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

```

### Вывод скрипта при запуске при тестировании:
```
vagrant@node1:~/netology/sysadm-homeworks$ ./3.py
/home/vagrant/netology/sysadm-homeworks/01-intro-01/README.md
/home/vagrant/netology/sysadm-homeworks/04-script-03-yaml/README.md

vagrant@node1:~/py/16$ ./3.py ~/netology/sysadm-homeworks
/home/vagrant/netology/sysadm-homeworks/01-intro-01/README.md
/home/vagrant/netology/sysadm-homeworks/04-script-03-yaml/README.md
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
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
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@node1:~/py/16$ ./4.py
2022-10-13 06:23:04 drive.google.com - 108.177.14.194
2022-10-13 06:23:05 mail.google.com - 216.58.210.165
2022-10-13 06:23:05 [ERROR] google.com IP mismatch: 64.233.162.139 - 64.233.162.138
2022-10-13 06:23:06 drive.google.com - 108.177.14.194
2022-10-13 06:23:06 mail.google.com - 216.58.210.165
2022-10-13 06:23:07 google.com - 64.233.162.138
2022-10-13 06:23:07 drive.google.com - 108.177.14.194
2022-10-13 06:23:08 mail.google.com - 216.58.210.165
2022-10-13 06:23:08 google.com - 64.233.162.138
2022-10-13 06:23:09 drive.google.com - 108.177.14.194
2022-10-13 06:23:10 mail.google.com - 216.58.210.165
2022-10-13 06:23:10 google.com - 64.233.162.138
```



