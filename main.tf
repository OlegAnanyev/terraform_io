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

resource "aws_security_group" "forwarder" {
  vpc_id = "vpc-0a3dd6dcde7ce95de"

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#resource "aws_key_pair" "key" {
#  public_key = "${var.public_key}"
#}

resource "aws_instance" "instance" {
  subnet_id     = "subnet-04393788dce09388a"
  ami           = data.aws_ami.ubuntu.id
  #key_name      = "${aws_key_pair.key.key_name}"
  instance_type = "t3.micro"
}