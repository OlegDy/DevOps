# Дамашнее задание 8, "3.3. Операционные системы, лекция 1"

## Олег Дьяченко DEVOPS-22

#### Какой системный вызов делает команда cd? В прошлом ДЗ мы выяснили, что cd не является самостоятельной программой, это shell builtin, поэтому запустить strace непосредственно на cd не получится. Тем не менее, вы можете запустить strace на /bin/bash -c 'cd /tmp'. В этом случае вы увидите полный список системных вызовов, которые делает сам bash при старте. Вам нужно найти тот единственный, который относится именно к cd.

    stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
    chdir("/tmp")                           = 0

#### Попробуйте использовать команду file на объекты разных типов на файловой системе. Используя strace выясните, где находится база данных file на основании которой она делает свои догадки.

   
    vagrant@vagrant:~$ strace file /dev/tty 2>&1 | grep magic
    openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
    stat("/home/vagrant/.magic.mgc", 0x7ffd4fdc38d0) = -1 ENOENT (No such file or directory)
    stat("/home/vagrant/.magic", 0x7ffd4fdc38d0) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
    stat("/etc/magic", {st_mode=S_IFREG|0644, st_size=111, ...}) = 0
    openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
    openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3

Ищет в разных местах, но нашел в самом последнем 
    
    openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
    fstat(3, {st_mode=S_IFREG|0644, st_size=5811536, ...}) = 0
    mmap(NULL, 5811536, PROT_READ|PROT_WRITE, MAP_PRIVATE, 3, 0) = 0x7efeba4f5000
    close(3)                                = 0

#### Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

           ├─sshd(732)─┬─sshd(710023)───sshd(710066)───bash(710069)───vim(732564)
           │           └─sshd(713526)───sshd(713568)───bash(713569)───mc(713588)───bash(713590)───pstree(732970)

    vagrant@vagrant:~$ lsof -p 732564
    vim     732564 vagrant    0u   CHR  136,1      0t0       4 /dev/pts/1
    vim     732564 vagrant    1u   CHR  136,1      0t0       4 /dev/pts/1
    vim     732564 vagrant    2u   CHR  136,1      0t0       4 /dev/pts/1
    vim     732564 vagrant    3u   REG  253,0    12288 1311819 /home/vagrant/.swp

    vagrant@vagrant:~$ rm /home/vagrant/.swp

    vagrant@vagrant:~$ lsof -p 732564
    vim     732564 vagrant    3u   REG  253,0    12288 1311819 /home/vagrant/.swp (deleted)

    vagrant@vagrant:~$ echo '' >/proc/732564/fd/3

    vim     732564 vagrant    3u   REG  253,0        1 1311819 /home/vagrant/.swp (deleted)

размер уменьшился с 12288 до 1

#### Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

Основная проблема, Зомби не занимают памяти (как процессы-сироты), но блокируют записи в таблице процессов, размер которой ограничен для каждого пользователя и системы в целом.

#### В iovisor BCC есть утилита opensnoop:
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты? Воспользуйтесь пакетом bpfcc-tools для Ubuntu 20.04.

    vagrant@vagrant:/usr/sbin$ sudo /usr/sbin/opensnoop-bpfcc -d 1
    PID    COMM               FD ERR PATH
    878    vminfo              4   0 /var/run/utmp
    664    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
    664    dbus-daemon        22   0 /usr/share/dbus-1/system-services
    664    dbus-daemon        -1   2 /lib/dbus-1/system-services
    664    dbus-daemon        22   0 /var/lib/snapd/dbus-1/system-services/
    738644 date                3   0 /etc/ld.so.cache
    738644 date                3   0 /lib/x86_64-linux-gnu/libc.so.6
    738644 date                3   0 /usr/lib/locale/locale-archive
    738644 date                3   0 /etc/localtime
    738645 sleep               3   0 /etc/ld.so.cache
    738645 sleep               3   0 /lib/x86_64-linux-gnu/libc.so.6
    738645 sleep               3   0 /usr/lib/locale/locale-archive
    670    irqbalance          6   0 /proc/interrupts
    670    irqbalance          6   0 /proc/stat
    670    irqbalance          6   0 /proc/irq/20/smp_affinity
    670    irqbalance          6   0 /proc/irq/0/smp_affinity
    670    irqbalance          6   0 /proc/irq/1/smp_affinity
    670    irqbalance          6   0 /proc/irq/8/smp_affinity
    670    irqbalance          6   0 /proc/irq/12/smp_affinity
    670    irqbalance          6   0 /proc/irq/14/smp_affinity
    670    irqbalance          6   0 /proc/irq/15/smp_affinity

#### Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС.

    vagrant@vagrant:/usr/sbin$ strace uname -a
    uname({sysname="Linux", nodename="vagrant", ...}) = 0
    fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(0x88, 0x5), ...}) = 0
    uname({sysname="Linux", nodename="vagrant", ...}) = 0
    uname({sysname="Linux", nodename="vagrant", ...}) = 0
    write(1, "Linux vagrant 5.4.0-110-generic "..., 108Linux vagrant 5.4.0-110-generic #124-Ubuntu SMP Thu Apr 14 19:46:19 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
    ) = 108

системный вызов uname()

    vagrant@vagrant:/usr/sbin$ man 2 uname
    ...
    Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.
    ...

#### Чем отличается последовательность команд через ; и через && в bash? Например:
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#

1. cmd1; cmd2 означает «выполнять эти команды последовательно, несмотря ни на что», 
1. cmd1 && cmd2 означает «выполнять эти команды, но немедленно останавливаться, если первая команда не удалась».
    
#### Есть ли смысл использовать в bash &&, если применить set -e?
Если указать оболочке перейти в режим «выход при ошибке», запустив set -e. 
В этом режиме оболочка завершает работу, как только любая команда возвратит ненулевое состояние. 
Таким образом, при set -e, ; фактически эквивалентно &&

По сути нет смысла использовать && в режиме set -e.

#### Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?

-е немедленный выход, если выходное состояние команды ненулевое.
-u во время замещения рассматривает незаданную переменную как ошибку.
-x выводит команды и их аргументы по мере выполнения команд.
-o pipefail - приведет к тому, что конвейер будет возвращать статус сбоя, если какая-либо команда не удалась.

устанавливает режим большего контроля за ошибками в наборе команд при выполнении сценария

#### Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе. В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

    vagrant@vagrant:~$ ps xa -o stat | grep S -c
    72
    vagrant@vagrant:~$ ps xa -o stat | grep I -c
    54

Больше всего процессов со статусом S, прерывистый сон (ожидание завершения события).
Дополнительный символы статуса, дополняют информацию о процессе.

    PROCESS STATE CODES
           Here are the different values that the s, stat and state output specifiers (header "STAT" or "S") will display to describe the state of a process:
    
                   D    uninterruptible sleep (usually IO)
                   I    Idle kernel thread
                   R    running or runnable (on run queue)
                   S    interruptible sleep (waiting for an event to complete)
                   T    stopped by job control signal
                   t    stopped by debugger during the tracing
                   W    paging (not valid since the 2.6.xx kernel)
                   X    dead (should never be seen)
                   Z    defunct ("zombie") process, terminated but not reaped by its parent
    
           For BSD formats and when the stat keyword is used, additional characters may be displayed:
    
                   <    high-priority (not nice to other users)
                   N    low-priority (nice to other users)
                   L    has pages locked into memory (for real-time and custom IO)
                   s    is a session leader
                   l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
                   +    is in the foreground process group



