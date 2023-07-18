#
#
#
#
#
#
# Lesson 8 Data source

provider "aws" {

}

#Taking arguments from provider
data "aws_availability_zones" "workzone" {}
data "aws_caller_identity" "current" {}
data "aws_region" "used" {}
data "aws_vpcs" "my_vpcs" {}
data "aws_vpc" "prod_vpc" {
  tags = {
    Name = "prod" #filter for search vpc
  }
}
#making 
resource "aws_subnet" "prod_subnet_1" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.workzone.names[0]
  cidr_block        = "172.31.0.0/24"
  tags = {
    Name    = "Subnet-1 in ${data.aws_availability_zones.workzone.names[0]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.used.description
  }
}

resource "aws_subnet" "prod_subnet_2" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.workzone.names[1]
  cidr_block        = "172.31.2.0/24"
  tags = {
    Name    = "Subnet-2 in ${data.aws_availability_zones.workzone.names[1]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.used.description
  }
}

output "data_aws_availability_zones" {
  value = data.aws_availability_zones.workzone.names #avaliability zone
}
output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id #account id 
}
output "data_aws_region_name" {
  value = data.aws_region.used.name #region name
}
output "data_aws_region_description" {
  value = data.aws_region.used.description #region description
}
output "data_aws_vpcs_ids" {
  value = data.aws_vpcs.my_vpcs.ids #vpcs all ids
}
output "data_aws_vpc_id" {
  value = data.aws_vpc.prod_vpc.id #vpc id
}
output "data_aws_vpc_cidr" {
  value = data.aws_vpc.prod_vpc.cidr_block #cidr block 
}


