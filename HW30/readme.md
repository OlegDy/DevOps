# Домашнее задание 30 [7.2. Облачные провайдеры и синтаксис Terraform.](https://github.com/netology-code/virt-homeworks/tree/virt-11/07-terraform-02-syntax)

## Олег Дьяченко DEVOPS-22

# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."

## Задача 1 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно).

1. Подробная инструкция на русском языке содержится [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
2. Обратите внимание на период бесплатного использования после регистрации аккаунта. 
3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки
базового терраформ конфига.
4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте терраформа, что бы 
не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

Ответ.

В предыдущих занятиях [(HW21)](https://github.com/OlegDy/DevOps/tree/main/HW21/05-virt-04-docker-compose/src/terraform) делали, просто повторил и настроил чтоб переменные 
не в файле передавались, а посредством переменных окружения.

```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)

Промучался 3 часа :), оказалось надо еще и в разном регистре делать переменные. Добавил эту переменную и взлетело.
export TF_VAR_yandex_folder_id=$YC_FOLDER_ID
```


## Задача 2. Создание aws ec2 или yandex_compute_instance через терраформ. 

1. В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf` и `versions.tf`.
2. Зарегистрируйте провайдер 
   [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
3. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунту. Поэтому в предыдущем задании мы указывали
их в виде переменных окружения. 
  
5. В файле `main.tf` создайте рессурс 
   либо [yandex_compute_image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_image).

7. Если вы выполнили первый пункт, то добейтесь того, что бы команда `terraform plan` выполнялась без ошибок. 


В качестве результата задания предоставьте:
1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?  
В Yandex образ делали Packer, думаю можно еще Ansible образ донастроить.
2. Ссылку на репозиторий с исходной конфигурацией терраформа.    
   Взял в предыдущих занятиях [(HW21)](https://github.com/OlegDy/DevOps/tree/main/HW21/05-virt-04-docker-compose/src/terraform) 

---

Появилось пару вопросов к Сергею Андрюнину:

1. В Терраформе получилось передать id и token посредством переменных окружения, а вот как в Packer его также передать что-то не нашел или плохо искал?
2. Заинтересовался вашей последней наработкой отслеживанием ESXi, сам в основном отслеживал долгие периоды в VeeamONE. 
   - как создавать образ первоначальный для ESXi, или самому просто поставить и потом что с ним сделать.
   - как доделаете, подскажете, сам всегда в записи смотрю, с Хабаровска. 


