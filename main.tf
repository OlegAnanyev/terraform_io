# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"
}

data "aws_ami" "ubuntu" {
  most_recent      = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "netology" {
  // из какого образа создать инстанс
  ami = data.aws_ami.ubuntu.id
  // тип инстанса
  instance_type = "t3.micro"
  count = 2

  associate_public_ip_address = true

  // назначим тэг
  tags = {
    Name = "${terraform.workspace}_Diplom_Netology"
  }
}

resource "aws_instance" "netology_for_each" {
  for_each = local.instances_count

  // из какого образа создать инстанс
  ami = data.aws_ami.ubuntu.id
  // тип инстанса
  instance_type = "t3.micro"
  
  // имя и внутренний ip назначим согласно массиву instances_count
  tags = {
    Name = "Netology_${each.key}"
  }
  private_ip = each.value

  lifecycle {
    create_before_destroy = true
  }
}


//
data "aws_caller_identity" "current" {}

//регион будет тот же, что задан в провайдере
data "aws_region" "current" {}


locals {
  netology_instance_type_map = {
    //в принципе типы инстансов для разных воркспейсов должны отличаться
    //но на бесплатном аккаунте в зоне eu-north-1 доступен только t3.micro
    stage = "t3.micro"
    prod = "t3.micro"
  }

  netology_instance_count_map = {
  stage = 1
  prod = 2
  }

  instances_count = {
    "one" = "172.31.0.5"
    "two" = "172.31.0.6"
    "three" = "172.31.0.7"
  }
}

