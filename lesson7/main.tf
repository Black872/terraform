#
#
#
#
#
#
# Lesson 7 resource creation order

#initialization aws provider
provider "aws" {}

resource "aws_default_vpc" "default" {}
#added elastic ip(static ip address) for webserver
resource "aws_eip" "static_ip" {
  instance = aws_instance.webserver7.id
  tags = {
    name  = "web server IP"
    owner = "Dark"
  }
}

#instance webserver
resource "aws_instance" "webserver7" {
  ami                    = "ami-07ce6ac5ac8a0ee6f"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver7_sec.id]
  # added dynamic user_data templatefile with few variables used with bash script
  user_data = templatefile("script.sh.tpl", {
    f_name = "Roman"
    l_name = "Larinov"
    names  = ["Sergey", "Pavel", "Tomas", "John"]
  })

  tags = {
    name  = "webserver7"
    owner = "Dark"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_instance.db_server, aws_instance.app_server]

}

resource "aws_instance" "app_server" {
  ami                    = "ami-07ce6ac5ac8a0ee6f"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver7_sec.id]

  tags = {
    name = "Server-Application"
  }
  depends_on = [aws_instance.db_server]
}
resource "aws_instance" "db_server" {
  ami                    = "ami-07ce6ac5ac8a0ee6f"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver7_sec.id]

  tags = {
    name = "Server-Database"
  }

}


# dynamic block security group with several ingress/egress rules
resource "aws_security_group" "webserver7_sec" {
  name        = "webserver 7 security group"
  description = "webserver 7 allow http/https/web"
  vpc_id      = aws_default_vpc.default.id # This need to be added since AWS Provider v4.29+ to set VPC id

  dynamic "ingress" {
    for_each = [
      {
        port        = "80",
        description = "web from internet",
        protocol    = "tcp"
      },
      {
        port        = "443",
        description = "web from internet",
        protocol    = "tcp"
      },
      {
        port        = "8080",
        description = "web from internet",
        protocol    = "tcp"
      },
      {
        port        = "8090",
        description = "web from internet",
        protocol    = "tcp"
      },
      {
        port        = "22"
        description = "ssh"
        protocol    = "tcp"
      },
    ]
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  #outcome trafic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name  = "dynamic security group"
    owner = "Dark"
  }
}
#added output.tf file, with all outputs
