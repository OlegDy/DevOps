# Provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
}

provider "yandex" {
  #service_account_key_file = "key.json"
  cloud_id  = "${var.yandex_cloud_id}"
  folder_id = "${var.yandex_folder_id}"
  zone      = "ru-central1-a"
}


#provider "yandex" {
#  token     = "<IAM-_или_OAuth-токен>"
#  cloud_id  = "<идентификатор_облака>"
#  folder_id = "<идентификатор_каталога>"
#  zone      = "ru-central1-a"
#}

resource "yandex_iam_service_account" "sa" {
  name = "sa-backet"
}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = "${var.yandex_folder_id}"
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

// Создание бакета с использованием ключа
resource "yandex_storage_bucket" "test" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "olegdydevops"
}

#output "keya" {
#  description = "access_key"
#  value = yandex_iam_service_account_static_access_key.sa-static-key.access_key
#}

#output "keys {
#  description = "secret_key"
#  value = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
#}