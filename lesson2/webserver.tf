#
#
#
#
#
# added static user_data file with bash script, security group with several ingress/egress rules
#
#

provider "aws" {
  region = "eu-central-1"
}

resource "aws_default_vpc" "default" {}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-07ce6ac5ac8a0ee6f"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Roma"
    l_name = "Larinov"
    names  = ["Vasya", "Kolya", "Petya", "Sergey", "Pavel", "Leonid"]
  })

  tags = {
    name  = "My first web server"
    owner = "Dark"
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "webserver security group"
  description = "firt webserver SG"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name  = "webserver security group"
    owner = "Dark"
  }

}


