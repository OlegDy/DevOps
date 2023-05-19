## Домашнее задание 53 [11.2 Микросервисы: принципы](https://github.com/netology-code/micros-homeworks/blob/main/11-microservices-02-principles.md)

### Олег Дьяченко DEVOPS-22

# Домашнее задание к занятию «Микросервисы: принципы»

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.

---
## Задача 1: API Gateway 

Предложите решение для обеспечения реализации API Gateway. Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.

Решение должно соответствовать следующим требованиям:
- маршрутизация запросов к нужному сервису на основе конфигурации,
- возможность проверки аутентификационной информации в запросах,
- обеспечение терминации HTTPS.

Обоснуйте свой выбор.

### Ответ

В связи с санкциями наложенными на нашу страну, решил ограничить выборку только open-source решениями.
Единственное если использовать облачные ресурсы нашего производства, то надо посмотреть выбор API того облака 
на котором располагаются наши сервисы.

Список шлюзов довольно обширный и не окончательный:
* Kong Gateway (OSS)
* Tyk
* KrakenD
* Apache APISIX API Gateway
* Apinto Microservice Gateway
* Gravitee.io API Platform
* Fusio
* Gloo Edge
* WSO2 API Microgateway
* Goku API Gateway
* API Umbrella
* Apiman
* SnapLogic
* Repose

Требования в задании к шлюзу имеют, на мой взляд, базовый функционал, которым должны обладать любой API шлюз.

В лидерах Kong и Tyk, но меня больше убедили графики активности GitHub с проекта Apache APISIX API Gateway, 
а также статья на эту тему.

![График](https://static.apiseven.com/2022/09/13/632055a37ac26.png?imageMogr2/format/webp)

Из графика видно, что Kong и Tyk начали свою работу примерно в 2015 году, а Apache APISIX и Gloo - позже, в 2019 году. Более того, мы также видим, что самый молодой Apache APISIX имеет самую крутую кривую среди всех них и набрал более 320 контрибьюторов, обогнав идущего на втором месте Kong на 57 человек, став проектом API-шлюза, имеющим наибольшее количество контрибьюторов.


На анализе статей и рейтингов я бы остановился на **Apache APISIX API Gateway**.


**Статьи**  
https://geekflare.com/api-gateway/   
https://nordicapis.com/6-open-source-api-gateways/  
https://api7.ai/blog/why-is-apache-apisix-the-best-api-gateway  
https://www.alibabacloud.com/ru/knowledge/hot/best-open-source-api-gateways-to-consider  
https://www.way2smile.ae/blog/top-10-open-source-api-gateways/  


---
## Задача 2: Брокер сообщений

Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.

Решение должно соответствовать следующим требованиям:
- поддержка кластеризации для обеспечения надёжности,
- хранение сообщений на диске в процессе доставки,
- высокая скорость работы,
- поддержка различных форматов сообщений,
- разделение прав доступа к различным потокам сообщений,
- простота эксплуатации.

Обоснуйте свой выбор.

### Ответ

Top Message Brokers:
* Memphis
* RabbitMQ
* Apache Kafka
* Apache ActiveMQ
* WSO2
* ZeroMQ

Снова, как и в первом варианте исследуем решения с открытым кодом.
Конечно много брокеров сообщений, но судя по обзорам все сводится к выбору между Kafka и RabbitMQ.

RabbitMQ более простой в настройке и более универсальный, a Kafka быстрая скорость, я думаю начать тестировать с RabbitMQ.

**Статьи**  
https://geekflare.com/top-message-brokers/  
https://blog.containerize.com/top-5-open-source-message-queue-software-in-2021/#:~:text=RabbitMQ%20is%20the%20most%20widely,to%20send%20and%20receive%20messages.  
https://hevodata.com/learn/popular-message-broker/  
https://slurm.io/tpost/phdmogo9y1-rabbitmq-i-apache-kafka-chto-vibrat-i-mo#:~:text=Kafka%20%D1%85%D1%80%D0%B0%D0%BD%D0%B8%D1%82%20%D0%B1%D0%BE%D0%BB%D1%8C%D1%88%D0%B8%D0%B5%20%D0%BE%D0%B1%D1%8A%D0%B5%D0%BC%D1%8B%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85,%D0%B4%D0%BE%D1%81%D1%82%D0%B0%D0%B2%D0%BB%D1%8F%D0%B5%D1%82%20%D1%81%D0%BE%D0%BE%D0%B1%D1%89%D0%B5%D0%BD%D0%B8%D1%8F%20%D1%86%D0%B8%D0%BA%D0%BB%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B8%20%D0%BA%D0%BE%D0%BD%D0%BA%D1%83%D1%80%D0%B8%D1%80%D1%83%D1%8E%D1%89%D0%B8%D0%BC%20%D0%BF%D0%BE%D0%BB%D1%83%D1%87%D0%B0%D1%82%D0%B5%D0%BB%D1%8F%D0%BC.  
https://habr.com/ru/companies/sberbank/articles/669456/  
https://habr.com/ru/companies/yandex_praktikum/articles/700608/  