# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Терраформ."

Зачастую разбираться в новых инструментах гораздо интересней понимая то, как они работают изнутри. 
Поэтому в рамках первого *необязательного* задания предлагается завести свою учетную запись в AWS (Amazon Web Services).

## Задача 1. Регистрация в aws и знакомство с основами (необязательно, но крайне желательно).

Остальные задания можно будет выполнять и без этого аккаунта, но с ним можно будет увидеть полный цикл процессов. 

AWS предоставляет достаточно много бесплатных ресурсов в первых год после регистрации, подробно описано [здесь](https://aws.amazon.com/free/).
1. Создайте аккаут aws.
2. Установите c aws-cli https://aws.amazon.com/cli/.
3. Выполните первичную настройку aws-sli https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html.

```
quattrox@Test:~$ aws configure
AWS Access Key ID [****************VDYP]:
AWS Secret Access Key [****************kr60]:
Default region name [eu-central-1]: 
Default output format [json]: 
```

4. Создайте IAM политику для терраформа c правами
    * AmazonEC2FullAccess
    * AmazonS3FullAccess
    * AmazonDynamoDBFullAccess
    * AmazonRDSFullAccess
    * CloudWatchFullAccess
    * IAMFullAccess

```
Добавил права:
```
![](https://github.com/rushx13/devops-netology/blob/main/Homework/07-terraform-02-syntax/iam.png)
```
Так же можно использовать код в json формате из веб интерфейса и использовать его в tf файле.
```

5. Добавьте переменные окружения 
    ```
    export AWS_ACCESS_KEY_ID=(your access key id)
    export AWS_SECRET_ACCESS_KEY=(your secret access key)
    ```
6. Создайте, остановите и удалите ec2 инстанс (любой с пометкой `free tier`) через веб интерфейс. 

В виде результата задания приложите вывод команды `aws configure list`.

```
quattrox@Test:~/devops-netology$ aws configure list
      Name                    Value             Type    Location
      ----                    -----             ----    --------
   profile                <not set>             None    None
access_key     ****************VDYP shared-credentials-file    
secret_key     ****************kr60 shared-credentials-file    
    region             eu-central-1      config-file    ~/.aws/config
```

## Задача 2. Созданием ec2 через терраформ. 

1. В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf` и `versions.tf`.
1. Зарегистрируйте провайдер для [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs). В файл `main.tf` добавьте
блок `provider`, а в `versions.tf` блок `terraform` с вложенным блоком `required_providers`. Укажите любой выбранный вами регион 
внутри блока `provider`.
1. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунта. Поэтому в предыдущем задании мы указывали
их в виде переменных окружения. 
1. В файле `main.tf` воспользуйтесь блоком `data "aws_ami` для поиска ami образа последнего Ubuntu.  
1. В файле `main.tf` создайте рессурс [ec2 instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance).
Постарайтесь указать как можно больше параметров для его определения. Минимальный набор параметров указан в первом блоке 
`Example Usage`, но желательно, указать большее количество параметров. 
1. Добавьте data-блоки `aws_caller_identity` и `aws_region`.
1. В файл `outputs.tf` поместить блоки `output` с данными об используемых в данный момент: 
    * AWS account ID,
    * AWS user ID,
    * AWS регион, который используется в данный момент, 
    * Приватный IP ec2 инстансы,
    * Идентификатор подсети в которой создан инстанс.  
1. Если вы выполнили первый пункт, то добейтесь того, что бы команда `terraform plan` выполнялась без ошибок. 


В качестве результата задания предоставьте:
1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
1. Ссылку на репозиторий с исходной конфигурацией терраформа.  
 
---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
