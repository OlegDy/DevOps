variable "yandex_cloud_id" {
  default = ""
}

variable "yandex_folder_id" {
  default = ""
}

locals {
  /*
  vms = {
    default = {
      default: 1
    },
    stage = {
      stage: 1
    },
    prod = {
      prod1: 1,
      prod2: 2
    }
  }
  */

  vms = {
    default = {
      node: 1,
    },
    stage = {
      node: 1,
    },
    prod = {
      node: 2,
      prod: 2,
    }
  }


  /*node_instance_count = {
    default = 1
    stage = 1
    prod = 2
  }*/

  node_cores = {
    default = 2
    stage = 2
    prod = 4
  }
  node_mems = {
    default = 4
    stage = 4
    prod = 8
  }
  node_disk_size = {
    default = 20
    stage = 20
    prod = 40
  }

}


//variable image { default = "centos-7" }

/*
data "yandex_compute_image" "image" {
  family = var.image
}
*/


module "instance" {
  for_each = local.vms[terraform.workspace]
  source = "./modules"
  instance_count = each.value

  subnet_id     = yandex_vpc_subnet.default.id
  zone = "ru-central1-a"
  folder_id = var.yandex_folder_id
  image         = "centos-7"
  platform_id   = "standard-v2"
  name          = each.key
  description   = "Modules test"
  users         = "centos"
  cores         = local.node_cores[terraform.workspace]
  boot_disk     = "network-ssd"
  disk_size     = local.node_disk_size[terraform.workspace]
  nat           = "true"
  memory        = local.node_mems[terraform.workspace]
  core_fraction = "100"

}

output "public_ip" {
  value = {
    for k, v in module.instance : k => v.instance_public_ip
  }
}
/*

resource "yandex_compute_instance" "instance" {
  count = local.node_instance_count[terraform.workspace]
  name = "count-${terraform.workspace}-${format("%01d", count.index+1)}"
  platform_id = "standard-v2"
  hostname = "count-${terraform.workspace}-${format("%01d", count.index+1)}"
  description = "Test count ${terraform.workspace}-${format("%01d", count.index+1)}"
  zone = "ru-central1-a"
  folder_id = var.yandex_folder_id

  resources {
    cores  = local.node_cores[terraform.workspace]
    memory = local.node_mems[terraform.workspace]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      type = "network-ssd"
      size = local.node_disk_size[terraform.workspace]
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "instance_each" {
  for_each = local.vms[terraform.workspace]
  name = "Each-${each.key}-${format("%01d", each.value)}"
  platform_id = "standard-v2"
  hostname = "Each-${each.key}-${format("%01d", each.value)}"
  description = "Test each ${each.key}-${format("%01d", each.value)}"
  zone = "ru-central1-a"
  folder_id = var.yandex_folder_id

  resources {
    cores  = local.node_cores[terraform.workspace]
    memory = local.node_mems[terraform.workspace]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      type = "network-ssd"
      size = local.node_disk_size[terraform.workspace]
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

*/






















###### Network
resource "yandex_vpc_network" "default" {
  name = "net"
}

resource "yandex_vpc_subnet" "default" {
  name = "subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["192.168.101.0/24"]
}




# Provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "olegdydevops"
    region     = "ru-central1"
    key        = "test_backet/backet.tfstate"


    access_key = "YCAJEm9LSkbsQ0RRifLkNahED"
    secret_key = "YCNHXIqvFVtqI7bK5glgLZEVpr9zyu4FqtK77giL"


    #access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    #secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    #access_key = "<идентификатор статического ключа>"
    #secret_key = "<секретный ключ>"

    skip_region_validation      = true
    skip_credentials_validation = true
  }


}

provider "yandex" {
  #service_account_key_file = "key.json"
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
}


#output "internal_ip_address_node01_yandex_cloud" {
#  value = "${yandex_compute_instance.node01.network_interface.0.ip_address}"
#}
#
#output "external_ip_address_node01_yandex_cloud" {
#  value = "${yandex_compute_instance.node01.network_interface.0.nat_ip_address}"
#}


#provider "yandex" {
#  token     = "<IAM-_или_OAuth-токен>"
#  cloud_id  = "<идентификатор_облака>"
#  folder_id = "<идентификатор_каталога>"
#  zone      = "ru-central1-a"
#}

/*
resource "yandex_iam_service_account" "sa" {
  name = "sa-backet"
}
*/


/*
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
*/




