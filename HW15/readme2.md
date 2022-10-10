# Дамашнее задание 15, "4.1. Командная оболочка Bash: Практические навыки"

## Олег Дьяченко DEVOPS-22


#### 1. Есть скрипт:
```bash
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```
	* Какие значения переменным c,d,e будут присвоены?
	* Почему?
```
c=a+b
vagrant@node1:~$ echo $c
a+b
```
потому что `a+b` это просто строка, набор символов, которая присвоена переменной `с`

```
d=$a+$b
vagrant@node1:~$ echo $d
1+2
```
потому что передается значение переменных разделенных знаком `+`, который в этом случае просто символ.
```
vagrant@node1:~$ e=$(($a+$b))
vagrant@node1:~$ echo $e
3
vagrant@node1:~$ ee=$[$a+$b]
vagrant@node1:~$ echo $ee
3
vagrant@node1:~$ let eee=$a+$b
vagrant@node1:~$ echo $eee
3
```
потому что конструкция `$((...))` предполагает вычисление значения, можно заменить так же еще другими способами.

#### 2. На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным. В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:

Исправный скрипт.
```bash
while ((1==1))
do
  curl https://localhost:4757
  if (($? != 0))
  then
    date >> curl.log
  else  
    echo "ok, online."
    break
  fi
  sleep 20
done
```

#### 3. Необходимо написать скрипт, который проверяет доступность трёх IP: 192.168.0.1, 173.194.222.113, 87.250.250.242 по 80 порту и записывает результат в файл log. Проверять доступность необходимо пять раз для каждого узла.

```bash
#!/usr/bin/env bash

array_ip=("google.com 77.88.55.80 192.168.60.2")

for ip in ${array_ip[@]}; do
  date >> test_ip.log
  echo "Test $ip" >> test_ip.log
  err=0
  for i in {0..4}; do
    curl $ip >> test_ip.log
    if (($? == 0)); then
        let "err=$err+1"
    fi
  done
    echo "-----------------" >> test_ip.log
    if (($err == 5)); then
        echo "$ip - ok, online" >> test_ip.log
    else
        echo "$ip - offline" >> test_ip.log
    fi
    echo "-----------------" >> test_ip.log
done
```
результат

```
Mon 10 Oct 2022 11:54:27 AM UTC
Test google.com
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.^M
</BODY></HTML>^M
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.^M
</BODY></HTML>^M
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.^M
</BODY></HTML>^M
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.^M
</BODY></HTML>^M
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.^M
</BODY></HTML>^M
-----------------
google.com - ok, online
-----------------
Mon 10 Oct 2022 11:54:29 AM UTC
Test 77.88.55.80
-----------------
77.88.55.80 - ok, online
-----------------
Mon 10 Oct 2022 11:54:30 AM UTC
Test 192.168.60.2
-----------------
192.168.60.2 - offline
-----------------
```

#### 4. Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается

/home/vagrant/ping_ip2.sh  
```bash
#!/usr/bin/env bash

array_ip=("77.88.55.80 192.168.60.2 google.com")

while ((1==1));do

 for ip in ${array_ip[@]}; do
  date >> test_ip.log
  echo "Test $ip" >> test_ip.log
  err=0
  for i in {0..4}; do
    curl $ip >> test_ip.log
    if (($? == 0)); then
        let "err=$err+1"
    fi
  done
    echo "-----------------" >> test_ip.log
    if (($err == 5)); then
        echo "$ip - ok, online" >> test_ip.log
    else
        echo "$ip - offline" >> test_ip.log
        echo "$ip - offline, error" >> error_ip.log
        exit
    fi
    echo "-----------------" >> test_ip.log
 done

done
```

/home/vagrant/test_ip.log
```
Test 77.88.55.80
-----------------
77.88.55.80 - ok, online
-----------------
Mon 10 Oct 2022 12:11:30 PM UTC
Test 192.168.60.2
-----------------
192.168.60.2 - offline
```

/home/vagrant/error_ip.log
```                                                        
192.168.60.2 - offline, error
```