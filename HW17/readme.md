# Дамашнее задание 17

## Олег Дьяченко DEVOPS-22


# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис
```
{ "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : "71.75.22.43"
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
```

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

Пришлось программу полностью переписать, можно было конечно по-простому, что просили то и вписать в файлы параметров, но для меня библиотеки должны помогать работать с параметрами, а то параметры я и так мог вычитать напрямую.

Единственное если я прошлое задание сделал только на листах (и я думал я извращенец), то тут пришлось в каждой записи листа вставлять дикт, чтобы вывод соответствовал вашей задаче.

Вопрос это реальная задача или просто для сложности добавили?

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import time
import datetime
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

```

### Вывод скрипта при запуске при тестировании:
```
2022-10-14 22:10:42 [ERROR] google.com IP mismatch: 64.233.162.100 - 64.233.162.138
2022-10-14 22:10:43 drive.google.com - 108.177.14.194
2022-10-14 22:10:43 mail.google.com - 142.250.74.37
2022-10-14 22:10:43 [ERROR] google.com IP mismatch: 64.233.162.138 - 64.233.162.113
2022-10-14 22:10:43 drive.google.com - 108.177.14.194
2022-10-14 22:10:44 mail.google.com - 142.250.74.37
2022-10-14 22:10:44 [ERROR] google.com IP mismatch: 64.233.162.113 - 64.233.162.102
2022-10-14 22:10:44 drive.google.com - 108.177.14.194
2022-10-14 22:10:44 mail.google.com - 142.250.74.37
2022-10-14 22:10:44 [ERROR] google.com IP mismatch: 64.233.162.102 - 64.233.162.139
2022-10-14 22:10:45 drive.google.com - 108.177.14.194
2022-10-14 22:10:45 mail.google.com - 142.250.74.37
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
[{"drive.google.com": "108.177.14.194"}, {"mail.google.com": "142.250.74.37"}, {"google.com": "64.233.162.139"}]
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
- drive.google.com: 108.177.14.194
- mail.google.com: 142.250.74.37
- google.com: 64.233.162.139
```