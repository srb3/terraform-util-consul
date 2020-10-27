provider "aws" {
  shared_credentials_file = var.aws_creds_file
  profile                 = var.aws_profile
  region                  = var.aws_region
}

data "aws_availability_zones" "available" {}

module "ami" {
  source  = "srb3/ami/aws"
  version = "0.13.0"
  os_name = "centos-7"
}

resource "random_id" "hash" {
  byte_length = 4
}

locals {
  public_subnets = ["10.0.1.0/24"]
  azs            = [
                     data.aws_availability_zones.available.names[0],
                     data.aws_availability_zones.available.names[1]
                   ]

  sg_data = {
    "consul" = {
      "ingress_rules" = ["ssh-tcp", "consul-webui-tcp"],
      "ingress_cidr"  = concat(var.ingress_cidrs,local.public_subnets),
      "egress_rules"  = ["all-all"],
      "egress_cidr"   = ["0.0.0.0/0"] 
      "description"   = "consul security group"
      "vpc_id"        = module.vpc.vpc_id
    }
  }

  vm_data = {
    "consul" = {
      "ami"                = module.ami.id,
      "instance_type"      = "t3.large",
      "key_name"           = var.aws_key_name,
      "security_group_ids" = [module.security_group["consul"].id],
      "subnet_ids"         = module.vpc.public_subnets,
      "root_block_device"  = [{ volume_type = "gp2", volume_size = "40" }]
      "public_ip_address"  = true
    }
  }

  consul_data = {
    "consul" = {
      "ip"                        = module.instance["consul"].public_ip[0],
      "user_name"                 = module.ami.user,
      "user_private_key"          = var.ssh_user_private_key,
      "populate_script"           = var.consul_populate_script,
      "datacenter"                = var.consul_datacenter,
      "port"                      = var.consul_port,
      "log_level"                 = var.consul_log_level
    }
  }
}

module "vpc" {
  source         = "srb3/vpc/aws"
  version        = "0.13.0"
  name           = "Automate and Squid vpc"
  cidr           = "10.0.0.0/16"
  azs            = local.azs
  public_subnets = local.public_subnets
  tags           = var.tags
}

module "security_group" {
  source              = "srb3/security-group/aws"
  version             = "0.13.1"
  for_each            = local.sg_data
  name                = each.key
  description         = each.value["description"]
  vpc_id              = each.value["vpc_id"]
  ingress_rules       = each.value["ingress_rules"]
  ingress_cidr_blocks = each.value["ingress_cidr"]
  egress_rules        = each.value["egress_rules"]
  egress_cidr_blocks  = each.value["egress_cidr"]
  tags                = var.tags
}

module "instance" {
  source                      = "srb3/vm/aws"
  version                     = "0.13.1"
  for_each                    = local.vm_data
  name                        = each.key
  ami                         = each.value["ami"]
  instance_type               = each.value["instance_type"]
  key_name                    = each.value["key_name"]
  security_group_ids          = each.value["security_group_ids"]
  subnet_ids                  = each.value["subnet_ids"]
  root_block_device           = each.value["root_block_device"]
  associate_public_ip_address = each.value["public_ip_address"] 
  tags                        = var.tags
}

module "consul" {
  source                    = "../../"
  for_each                  = local.consul_data
  ip                        = each.value["ip"]
  user_name                 = each.value["user_name"]
  user_private_key          = each.value["user_private_key"]
  populate_script           = each.value["populate_script"]
  datacenter                = each.value["datacenter"]
  port                      = each.value["port"]
  log_level                 = each.value["log_level"]
  depends_on                = [module.instance]
}

provider "consul" {
  address = length(module.instance["consul"].public_ip) >0 ? "${module.instance["consul"].public_ip[0]}:${var.consul_port}" : ""
}

data "consul_keys" "test_data" {
  depends_on = [module.consul]
  datacenter = var.consul_datacenter
  key {
    name = "data"
    path = "test-data"
  }
}

locals {
  test_data = jsondecode(data.consul_keys.test_data.var.data)
}
