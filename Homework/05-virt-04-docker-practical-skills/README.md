# Домашнее задание к занятию "5.4. Практические навыки работы с Docker"

## Задача 1 

В данном задании вы научитесь изменять существующие Dockerfile, адаптируя их под нужный инфраструктурный стек.

Измените базовый образ предложенного Dockerfile на Arch Linux c сохранением его функциональности.

```text
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:vincent-c/ponysay && \
    apt-get update
 
RUN apt-get install -y ponysay

ENTRYPOINT ["/usr/bin/ponysay"]
CMD ["Hey, netology”]
```
Для получения зачета, вам необходимо предоставить:
- Написанный вами Dockerfile
- Скриншот вывода командной строки после запуска контейнера из вашего базового образа
- Ссылку на образ в вашем хранилище docker-hub

Ответ:

```
FROM archlinux:latest

RUN pacman -Sy

RUN pacman -Su --noconfirm ponysay

ENTRYPOINT ["/usr/bin/ponysay"]
CMD ["Hey, netology”]

```
Скриншот:

![](https://github.com/rushx13/devops-netology/blob/main/Homework/05-virt-04-docker-practical-skills/Task1/ponysay_screenshot.png)

[Ссылка на образ](https://hub.docker.com/layers/rushx13/ponysay/latest/images/sha256-6069fac73a42d7da66bc6c4511cdb30b7f5cb0d7da7d9c277f50d232b50dad97?context=repo "Мой образ ponysay")

## Задача 2 

В данной задаче вы составите несколько разных Dockerfile для проекта Jenkins, опубликуем образ в `dockerhub.io` и посмотрим логи этих контейнеров.

- Составьте 2 Dockerfile:

    - Общие моменты:
        - Образ должен запускать [Jenkins server](https://www.jenkins.io/download/)
        
    - Спецификация первого образа:
        - Базовый образ - [amazoncorreto](https://hub.docker.com/_/amazoncorretto)
        - Присвоить образу тэг `ver1` 
    
    - Спецификация второго образа:
        - Базовый образ - [ubuntu:latest](https://hub.docker.com/_/ubuntu)
        - Присвоить образу тэг `ver2` 

- Соберите 2 образа по полученным Dockerfile
- Запустите и проверьте их работоспособность
- Опубликуйте образы в своём dockerhub.io хранилище

Для получения зачета, вам необходимо предоставить:
- Наполнения 2х Dockerfile из задания
- Скриншоты логов запущенных вами контейнеров (из командной строки)
- Скриншоты веб-интерфейса Jenkins запущенных вами контейнеров (достаточно 1 скриншота на контейнер)
- Ссылки на образы в вашем хранилище docker-hub


## Ответ:

Наполнения 2х Dockerfile из задания

Dockerfile.amazoncorretto:

```
FROM amazoncorretto:latest
MAINTAINER Rushx13

ADD https://pkg.jenkins.io/redhat-stable/jenkins.repo /etc/yum.repos.d/jenkins.>

RUN rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key && \
    yum update -y && \
    yum install -y jenkins

EXPOSE 8080/tcp

EXPOSE 50000

USER jenkins

CMD ["-jar", "/usr/lib/jenkins/jenkins.war"]

ENTRYPOINT ["java"]

```


Dockerfile.ubuntulatest


```
FROM ubuntu:latest

MAINTAINER Rushx13

ADD https://pkg.jenkins.io/debian-stable/jenkins.io.key /

RUN apt-get update -y && \
    apt-get install -y gnupg ca-certificates && \
    apt-key add /jenkins.io.key && \
    bash -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' && \
    apt-get update -y && \
    apt-get install -y openjdk-8-jdk openjdk-8-jre jenkins

EXPOSE 8080/tcp

EXPOSE 5000

USER jenkins

WORKDIR "/usr/share/jenkins"

CMD ["-jar", "jenkins.war"]

ENTRYPOINT ["java"]

```

- Скриншоты логов запущенных вами контейнеров (из командной строки)

![](https://github.com/rushx13/devops-netology/blob/main/Homework/05-virt-04-docker-practical-skills/Task2/log1_amazon.png)

![](https://github.com/rushx13/devops-netology/blob/main/Homework/05-virt-04-docker-practical-skills/Task2/log2_ubuntu.png)


- Скриншоты веб-интерфейса Jenkins запущенных вами контейнеров (достаточно 1 скриншота на контейнер)

![](https://github.com/rushx13/devops-netology/blob/main/Homework/05-virt-04-docker-practical-skills/Task2/screenshot_amazoncorretto.png)

![](https://github.com/rushx13/devops-netology/blob/main/Homework/05-virt-04-docker-practical-skills/Task2/screenshot_ubuntu.png)


- Ссылки на образы в вашем хранилище docker-hub


[Ссылка на образ jenkins_amazoncorretto](https://hub.docker.com/layers/rushx13/jenkins_amazoncorretto/latest/images/sha256-c291073404678f21d8f96884e5a55d05be77c4e7eb57a839270ec899c5580b38?context=repo)

[Ссылка на образ jenkins_ununtu](https://hub.docker.com/layers/rushx13/jenkins_ubuntu/latest/images/sha256-7f4168d0d0f1a2af639bf22d105fa0946be02a629177dc997ccc2456faeb9ae2?context=repo)




## Задача 3 

В данном задании вы научитесь:
- объединять контейнеры в единую сеть
- исполнять команды "изнутри" контейнера

Для выполнения задания вам нужно:
- Написать Dockerfile: 
    - Использовать образ https://hub.docker.com/_/node как базовый
    - Установить необходимые зависимые библиотеки для запуска npm приложения https://github.com/simplicitesoftware/nodejs-demo
    - Выставить у приложения (и контейнера) порт 3000 для прослушки входящих запросов  
    - Соберите образ и запустите контейнер в фоновом режиме с публикацией порта

- Запустить второй контейнер из образа ubuntu:latest 
- Создайть `docker network` и добавьте в нее оба запущенных контейнера
- Используя `docker exec` запустить командную строку контейнера `ubuntu` в интерактивном режиме
- Используя утилиту `curl` вызвать путь `/` контейнера с npm приложением  

Для получения зачета, вам необходимо предоставить:
- Наполнение Dockerfile с npm приложением
- Скриншот вывода вызова команды списка docker сетей (docker network cli)
- Скриншот вызова утилиты curl с успешным ответом

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
