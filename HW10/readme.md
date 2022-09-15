# Дамашнее задание 9, "3.5. Файловые системы"

## Олег Дьяченко DEVOPS-22


#### 1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.
    
Прочитал ссылку, и так в интернете поискал. Что-то особого применения с наскока не нашел. Везде написано как создавать, даже под винду, а для чего не написано. Понятно что меньше места занимает, но в чем преимущество.
Использую в основном сейчас дедупликацию, эффективность этого 50-60% на обычных файлах. На образах еще больше.

#### 2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
 
   Нет не могут, это особенность хардлинков. 
   
   ```bash
    vagrant@vagrant:~/1$ echo 111111 > test1.txt
    vagrant@vagrant:~/1$ ll
    total 12
    drwxrwxr-x 2 vagrant vagrant 4096 Sep 14 06:37 ./
    drwxr-xr-x 7 vagrant vagrant 4096 Sep 14 06:36 ../
    -rw-rw-r-- 1 vagrant vagrant    7 Sep 14 06:37 test1.txt
    vagrant@vagrant:~/1$ ln test1.txt test2.txt
    vagrant@vagrant:~/1$ ll
    total 16
    drwxrwxr-x 2 vagrant vagrant 4096 Sep 14 06:38 ./
    drwxr-xr-x 7 vagrant vagrant 4096 Sep 14 06:36 ../
    -rw-rw-r-- 2 vagrant vagrant    7 Sep 14 06:37 test1.txt
    -rw-rw-r-- 2 vagrant vagrant    7 Sep 14 06:37 test2.txt
    vagrant@vagrant:~/1$ chmod 0755 test1.txt
    vagrant@vagrant:~/1$ ll
    total 16
    drwxrwxr-x 2 vagrant vagrant 4096 Sep 14 06:38 ./
    drwxr-xr-x 7 vagrant vagrant 4096 Sep 14 06:36 ../
    -rwxr-xr-x 2 vagrant vagrant    7 Sep 14 06:37 test1.txt*
    -rwxr-xr-x 2 vagrant vagrant    7 Sep 14 06:37 test2.txt*
   ```

#### 3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```
Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

    vagrant@vagrant:~/1$ lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part /boot
    └─sda3                      8:3    0 62.5G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
    sdb                         8:16   0  2.5G  0 disk
    sdc                         8:32   0  2.5G  0 disk
    
#### 4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

    Device     Boot   Start     End Sectors  Size Id Type
    /dev/sdb1          2048 4196351 4194304    2G 83 Linux
    /dev/sdb2       4196352 5242879 1046528  511M 83 Linux

#### 5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.
    
    vagrant@vagrant:~/1$ sudo sfdisk -d /dev/sdb | sudo sfdisk --force /dev/sdc

    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    └─sdb2                      8:18   0  511M  0 part
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    └─sdc2                      8:34   0  511M  0 part

#### 6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

    vagrant@vagrant:~/1$ sudo mdadm --create --verbose /dev/md1 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
    mdadm: Note: this array has metadata at the start and
        may not be suitable as a boot device.  If you plan to
        store '/boot' on this device please ensure that
        your boot-loader understands md/v1.x metadata, or use
        --metadata=0.90
    mdadm: size set to 2094080K
    Continue creating array?
    Continue creating array? (y/n) y
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md1 started.

#### 7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

    vagrant@vagrant:~/1$ sudo mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
    mdadm: chunk size defaults to 512K
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md0 started.

    vagrant@vagrant:/$ cat /proc/mdstat
    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
    md0 : active raid0 sdc2[1] sdb2[0]
          1042432 blocks super 1.2 512k chunks
    
    md1 : active raid1 sdc1[1] sdb1[0]
          2094080 blocks super 1.2 [2/2] [UU]


#### 8. Создайте 2 независимых PV на получившихся md-устройствах.

    vagrant@vagrant:~$ sudo pvcreate /dev/md0 /dev/md1
      Physical volume "/dev/md0" successfully created.
      Physical volume "/dev/md1" successfully created.

#### 9. Создайте общую volume-group на этих двух PV.

    vagrant@vagrant:~$ sudo vgcreate vg01 /dev/md0 /dev/md1
      Volume group "vg01" successfully created

#### 10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

    vagrant@vagrant:~$ sudo lvcreate -L 100M vg01 /dev/md0
      Logical volume "lvol0" created.
    vagrant@vagrant:~$ sudo vgs
      VG        #PV #LV #SN Attr   VSize   VFree
      ubuntu-vg   1   1   0 wz--n- <62.50g 31.25g
      vg01        2   1   0 wz--n-  <2.99g  2.89g
    vagrant@vagrant:~$ sudo lvs
      LV        VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
      ubuntu-lv ubuntu-vg -wi-ao---- <31.25g
      lvol0     vg01      -wi-a----- 100.00m

#### 11. Создайте `mkfs.ext4` ФС на получившемся LV.

    vagrant@vagrant:~$ sudo mkfs.ext4 /dev/vg01/lvol0
    mke2fs 1.45.5 (07-Jan-2020)
    Creating filesystem with 25600 4k blocks and 25600 inodes
    
    Allocating group tables: done
    Writing inode tables: done
    Creating journal (1024 blocks): done
    Writing superblocks and filesystem accounting information: done

#### 12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

    vagrant@vagrant:~$ mkdir /tmp/lvm
    vagrant@vagrant:~$ sudo mount /dev/vg01/lvol0 /tmp/lvm

#### 13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

    vagrant@vagrant:~$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/lvm/test.gz
    --2022-09-15 00:45:17--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
    Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
    Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 22403740 (21M) [application/octet-stream]
    Saving to: ‘/tmp/lvm/test.gz’
    
    /tmp/lvm/test.gz                                            100%[========================================================================================================================================>]  21.37M  1.24MB/s    in 23s
    
    2022-09-15 00:45:42 (944 KB/s) - ‘/tmp/lvm/test.gz’ saved [22403740/22403740]


#### 14. Прикрепите вывод `lsblk`.

    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part  /boot
    └─sda3                      8:3    0 62.5G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    │ └─md1                     9:1    0    2G  0 raid1
    └─sdb2                      8:18   0  511M  0 part
      └─md0                     9:0    0 1018M  0 raid0
        └─vg01-lvol0          253:1    0  100M  0 lvm   /tmp/lvm
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    │ └─md1                     9:1    0    2G  0 raid1
    └─sdc2                      8:34   0  511M  0 part
      └─md0                     9:0    0 1018M  0 raid0
        └─vg01-lvol0          253:1    0  100M  0 lvm   /tmp/lvm


#### 15. Протестируйте целостность файла:

    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    
    vagrant@vagrant:~$ gzip -t /tmp/lvm/test.gz
    vagrant@vagrant:~$ echo $?
    0

#### 16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

    vagrant@vagrant:~$ sudo pvmove /dev/md0 /dev/md1
      /dev/md0: Moved: 12.00%
      /dev/md0: Moved: 100.00%
    
    vagrant@vagrant:~$ lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    loop0                       7:0    0 67.2M  1 loop  /snap/lxd/21835
    loop2                       7:2    0 61.9M  1 loop  /snap/core20/1328
    loop3                       7:3    0   47M  1 loop  /snap/snapd/16292
    loop4                       7:4    0 63.2M  1 loop  /snap/core20/1623
    loop5                       7:5    0 67.8M  1 loop  /snap/lxd/22753
    loop6                       7:6    0   48M  1 loop  /snap/snapd/16778
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part  /boot
    └─sda3                      8:3    0 62.5G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    │ └─md1                     9:1    0    2G  0 raid1
    │   └─vg01-lvol0          253:1    0  100M  0 lvm   /tmp/lvm
    └─sdb2                      8:18   0  511M  0 part
      └─md0                     9:0    0 1018M  0 raid0
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    │ └─md1                     9:1    0    2G  0 raid1
    │   └─vg01-lvol0          253:1    0  100M  0 lvm   /tmp/lvm
    └─sdc2                      8:34   0  511M  0 part
      └─md0                     9:0    0 1018M  0 raid0

#### 17. Сделайте `--fail` на устройство в вашем RAID1 md.

    vagrant@vagrant:~$ sudo mdadm /dev/md1 --fail /dev/sdb1
    mdadm: set /dev/sdb1 faulty in /dev/md1

    vagrant@vagrant:~$ sudo mdadm -D /dev/md1
    /dev/md1:
               Version : 1.2
         Creation Time : Wed Sep 14 07:27:59 2022
            Raid Level : raid1
            Array Size : 2094080 (2045.00 MiB 2144.34 MB)
         Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
          Raid Devices : 2
         Total Devices : 2
           Persistence : Superblock is persistent
    
           Update Time : Thu Sep 15 01:47:31 2022
                 State : clean, degraded
        Active Devices : 1
       Working Devices : 1
        Failed Devices : 1
         Spare Devices : 0
    
    Consistency Policy : resync
    
                  Name : vagrant:1  (local to host vagrant)
                  UUID : 8a89e26b:1a0c3379:a71ae28c:d24bc801
                Events : 41
    
        Number   Major   Minor   RaidDevice State
           -       0        0        0      removed
           1       8       33        1      active sync   /dev/sdc1
    
           2       8       17        -      faulty   /dev/sdb1

#### 18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

    vagrant@vagrant:~$ dmesg |grep md1
    [173721.523421] md/raid1:md1: Disk failure on sdb1, disabling device.
                    md/raid1:md1: Operation continuing on 1 devices.

#### 19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

    vagrant@vagrant:~$ gzip -t /tmp/lvm/test.gz && echo $?
    0

#### 20. Погасите тестовый хост, `vagrant destroy`.

Пока не получу зачет не уничтожу :)
Просто выключил.

    C:\HashiCorp\Home>vagrant.exe halt  
    ==> default: Attempting graceful shutdown of VM... 