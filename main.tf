module "vpc_handson2" {
  source = "./vpc_module"
  cidr_block = "10.0.0.0/24"
  vpc_tag = "vpc_handson2"
}

module "subnets" {
source = "./subnet_module"

for_each = {
    "public_1a" = ["10.0.0.0/26", "us-east-1a", "true", "public_1a"]
    "private_1a" = ["10.0.0.64/26", "us-east-1a", "false", "private_1a"]
    "public_1b" = ["10.0.0.128/26", "us-east-1b", "true", "public_1b"]
    "private_1b" = ["10.0.0.192/26", "us-east-1b", "false", "private_1b"]
}

vpc = module.vpc_handson2.id
cidr_block = each.value[0]
availability_zone = each.value[1]
map_public_ip_on_launch = each.value[2]
subnet_tag = each.value[3]
}

module "igw_handson2" {
  source = "./igw_module"

  vpc = module.vpc_handson2.id
  igw_tag = "igw_handson2"
}

module "natgw_handson2" {
  source = "./natgw_module"

  subnet_id = module.subnets["public_1a"].id
  natgw_tag = "natgw_handson2"
}