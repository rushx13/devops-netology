provider "aws" {
  access_key = "my_access_key"
  secret_key = "my_secret_key"
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

data "aws_caller_identity" "current" {
}

data "aws_region""current" {
}
