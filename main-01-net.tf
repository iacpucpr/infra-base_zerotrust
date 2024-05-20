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
   api_token = var.twingate_api-token
   network   = var.twingate_login

}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "twingate_remote_network" "twingate_net" {
  name = "twingate_net"
}
resource "docker_network" "twingate_net" {
  name = "twingate_net"
}
resource "docker_network" "network_1" {
  name = "network_1"
  ipam_config {
    subnet = "172.16.0.4/30"
  }
}
resource "docker_network" "network_2" {
  name = "network_2"
  ipam_config {
    subnet = "172.16.0.8/30"
  }
}
resource "docker_network" "network_3" {
  name = "network_3"
  ipam_config {
    subnet = "172.16.0.12/30"
  }
}
resource "docker_network" "network_4" {
  name = "network_4"
  ipam_config {
    subnet = "172.16.0.16/30"
  }
}
resource "docker_network" "network_5" {
  name = "network_5"
  ipam_config {
    subnet = "172.16.0.20/30"
  }
}
