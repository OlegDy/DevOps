## Домашнее задание 52 [11.1 Введение в микросервисы](https://github.com/netology-code/micros-homeworks/blob/main/11-microservices-01-intro.md)

### Олег Дьяченко DEVOPS-22

# Домашнее задание к занятию «Введение в микросервисы»

## Задача 1: Интернет Магазин

Руководство крупного интернет-магазина, у которого постоянно растёт пользовательская база и количество заказов, рассматривает возможность переделки своей внутренней   ИТ-системы на основе микросервисов. 

Вас пригласили в качестве консультанта для оценки целесообразности перехода на микросервисную архитектуру. 

Опишите, какие выгоды может получить компания от перехода на микросервисную архитектуру и какие проблемы нужно решить в первую очередь.

### Ответ

Интернет-магазин крупный уже, значит у них уже есть бизнес процессы и они работают и система 
основана на монолите. Наша задача переделать на микросервисы.

**Выгоды при переходе на микросервисную архитектуру:**

- Возможность использовать разные технологии и языки разработки микросервисов, которые больше подходят под
конкретную задачу, использовать уже готовые микросервисы, реализующие какой-то стандартный функционал;
- Повышение надежности и безопасности, сбой одного микросервиса, не ведет к выходу из строя всей системы;
- Масштабирование наиболее загруженных микросервисов и включение механизма балансировки;
- Возможность относительно простого развертывания отдельных сервисов;
- Возможность обеспечить более простую замену отдельно усовершенствованных микросервисов;
- Распределить ответственность разработчиков или команд, ограничивая ее списком конкретных микросервисов;
- Обеспечить более быстрое и частое обновление отдельных функциональных узлов 
и возможностей интернет-магазина.


**Для перехода на микросервисную архитектуру в первую очередь потребуется решить следующие проблемы:**

- Тщательно продумать функциональное назначение и бизнес-логику каждого из микросервисов, объединить по смыслу;
- Определиться со стандартами взаимодействия между микросервисами (API и безопасность);
- Переписать часть кода проекта для обеспечения работы микросервисов;
- Усилить штат специалистов, выполняющий сопровождение разработки и развертывания новых функциональных возможностей; 
- Возможно будет иметь смысл усовершенствовать автоматизацию сборки и тестирования разрабатываемых микросервисов;
- Потребуется выполнять больше работ по документированию разработки, а также усовершенствовать инфраструктуру, 
необходимую для разработки;
- Усовершенствовать подходы к эксплуатации ИТ-системы, обеспечить детальный мониторинг и логирование каждого из микросервисов и ИТ-системы в целом;
- Желательно автоматизировать процессы управления настройками и инфраструктурой за счет использования соответствующих инструментов (Ansible, Terraform);
- Желательно внедрить систему оркестрации микросервисов (Docker Swarm или Kubernetes);
- Заложить больший бюджет затрат, стоимость разработки и содержания микросервисных решений выше чем у обычных монолитных приложений. 

В целом нужно понимать, что преход на микросервисную архитектуру, это большой и трудоемкий процесс, который потребует финансовых, технических и временных затрат.

