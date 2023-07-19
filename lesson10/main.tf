#----------------------------------------
#Lesson 10 Highly available web in any region default vpc 
#Create:
#   Security group for webserver
#   Launch with auto AMI Lookup
#   Auto Scaling Group using 2 availability zones    
#   Classic Load Balancer in 2 availability zones
#
#----------------------------------------

provider "aws" {
  region = "eu-central-1"
}

data "aws_availability_zones" "available" {}
data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*-x86_64-gp2"]
  }
}
#----------------------------------------
resource "aws_default_vpc" "default" {}
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}
#----------------------------------------
resource "aws_security_group" "websg" {
  name = "Security group"

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/24"]
    }
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/24"]
  }

  tags = {
    name  = "webserver securitygroup"
    owner = "Dark"
  }
}
#create instance
resource "aws_launch_configuration" "weblauch" {
  name            = "Webserver-Highly-Available-LC"
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.websg.id]
  user_data       = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "webscal" {
  name                 = "Webserver-Highly-Available-ASG"
  launch_configuration = aws_launch_configuration.weblaunch.name
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  load_balancers       = [aws_elb.webelb.name]

  dynamic "tag" {
    for_each = {
      Name  = "Webserver in ASG"
      Owner = "Dark"

    }
    content {
      key                = tag.value
      value              = tag.value
      propagate_at_lauch = true
    }
    lifecycle {
      create_before_destroy = true
    }
  }

  resource "aws_elb" "webelb" {
    name               = "WebServer-HA-ELB"
    availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
    security_group     = [aws_security_group.websg.id]
    listener {
      lb_port           = 80
      lb_protocol       = "http"
      instance_port     = 80
      instance_protocol = "http"
    }
    healty_check {
      healty_treshold   = 2
      unhealty_treshold = 2
      timeout           = 3
      targer            = "HTTP:80/"
      interval          = 10
    }
    tags = {
      Name = "WebServer-Highly-Available-ELB"
    }
  }
}


