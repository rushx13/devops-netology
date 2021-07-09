provider "aws" {
  access_key = "XXXX"
  secret_key = "YYYY"
  region = "eu-central-1"
}

data "aws_ami" "Ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical

}

resource "aws_instance" "test-ec2" {

  ami = "data.aws_ami.ubuntu.id"

  instance_type = "t2.micro"

  cpu_core_count = "1"

  hibernation = "true"

  monitoring = "false"

}

data "aws_caller_identity" "current" {
}

data "aws_region""current" {
}
