#--------------------------------------------
#
#
#
#Lesson 9 autosearch AMI ids with Data Source
#--------------------------------------------

provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "latest_ubuntu" {
  owners      = ["540236827367"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Ubuntu_20.04-x86_64-SQL*"]
  }
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_ami" "latest_windows_server" {
  owners      = ["801119661308"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English*"]
  }
}



