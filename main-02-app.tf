resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "nginx"
  restart = "always"
  #network_mode = "twingate_net"
  network_mode = "network_1"
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
  network_mode = "network_2"
  

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
  network_mode = "network_3"
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
  network_mode = "network_4"
  
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
