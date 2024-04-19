terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
    twingate = {
      source = "Twingate/twingate"
      version = "3.0.0"
    }
  }
}

provider "twingate" {
  api_token = "EkXjaEg5gjbh3kcgjGh2dSdc8bcZKpvUnVIuziVJwR68KkPd9BJXnqIWUjELX8zwkW-8VFvHTRsLY4CGqMWeMS6Q2gWZwUVm3vdXWxnG8DeKx6rQgEONT2gMEbnuxAGrMS60zw"
  network   = "fellipeveiga"
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

#resource "docker_network" "wordpress_net" {
#  name = "wordpress_net"
#  ipam_config {
#    subnet = "172.16.0.0/24"
#  }
#}
#resource "docker_network" "kalilinux_net" {
#  name = "kalilinux_net"
#  ipam_config {
#    subnet = "172.16.1.0/24"
#  }
#}
#
resource "twingate_remote_network" "twingate_net" {
  name = "twingate_net"
}
resource "docker_network" "twingate_net" {
  name = "twingate_net"
  ipam_config {
    subnet = "172.16.0.0/24"
  }

}

# Download the latest Kali Linux Docker image
resource "docker_image" "kalilinux" {
  name = "kalilinux/kali-rolling:latest"
  keep_locally = false
}
 
## Run container kalilinux based on the image
#resource "docker_container" "kalilinux" {
#
#  image = docker_image.kalilinux.image_id
#  
#  name  = "KaliLinux"
#  network_mode = "twingate_net"
#  restart = "always"
#
#  ports {
#    internal = 81
#    external = 8001
#  }
#
## The Kali image will exit unless there is a long running command
#  command = [
#    "tail",
#    "-f",
#    "/dev/null"
#  ]
#
#}
#
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "nginx"
  restart = "always"
  #network_mode = "wordpress_net"
  network_mode = "twingate_net"
  ports {
    internal = 80
    external = 8000
  }
}

resource "docker_volume" "db_data" {}

resource "docker_container" "db" {
  name  = "db"
  image = "mysql:5.7"
  restart = "always"
  #network_mode = "wordpress_net"
  network_mode = "twingate_net"
  env = [
     "MYSQL_ROOT_PASSWORD=wordpress",
     "MYSQL_PASSWORD=wordpress",
     "MYSQL_USER=wordpress",
     "MYSQL_DATABASE=wordpress"
  ]
  mounts {
    type = "volume"
    target = "/var/lib/mysql"
    source = "db_data"
  }
}

resource "docker_container" "wordpress" {
  name  = "wordpress"
  image = "wordpress:latest"
  restart = "always"
  #network_mode = "wordpress_net"
  network_mode = "twingate_net"
  env = [
    "WORDPRESS_DB_HOST=db:3306",
    "WORDPRESS_DB_PASSWORD=wordpress",
    "WORDPRESS_DB_USER=wordpress",
    "WORDPRESS_DB_NAME=wordpress"
  ]
  ports {
    internal = "80"
    external = "${var.wordpress_port}"
  }
}

# Recurso de execucao local para invocar o script Bash
resource "null_resource" "run_random_docker_command" {
  triggers = {
    always_run = "${timestamp()}"
  }

}
resource "docker_image" "backup" {
  name = "ubuntu:latest"
}

# Creating a Docker Container using the latest ubuntu image.
resource "docker_container" "backup" {
  image             = docker_image.backup.image_id
  name              = "backup"
  must_run          = true
  publish_all_ports = true
  #network_mode = "wordpress_net"
  network_mode = "twingate_net"
  ports {
    internal = 22
    external = 222
  }
  command = [
    "tail",
    "-f",
    "/dev/null"
  ]
}

variable wordpress_port {
  default = "8080"
}


