# devops-netology
Test
Test2

Будут проигнорированы следующие файлы благодаря .gitignore:
1. Директории внутри папки terraform
2. Файлы с расширениями *.tfstate и файлы в которых упомянается *.tfstate.*
3. Файлы *.tfvars (содержат информацию паролей, ключей, и прочей важно информации, которая не должна быть раскрыта)
4. Файлы obverride.tf, override.tf.json, *_override.tf, *_override.tf.json, используются для перезаписи локальных ресурсов и не должны попадать в комит.
5. Игнорировать конфигурационные файлы интерфейса terraform: .terraformrc и terraform.rc

Добавил метку Fix по хэш изменения "Prepare to delete and move"
