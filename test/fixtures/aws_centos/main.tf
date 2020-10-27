module "aws_centos_consul" {
  source                 = "../../../examples/aws_centos"
  aws_region             = var.aws_region
  aws_profile            = var.aws_profile
  aws_creds_file         = var.aws_creds_file
  aws_key_name           = var.aws_key_name
  ingress_cidrs          = var.ingress_cidrs
  ssh_user_private_key   = var.ssh_user_private_key
  consul_port            = var.consul_port
  consul_log_level       = var.consul_log_level
  consul_datacenter      = var.consul_datacenter
  consul_populate_script = var.consul_populate_script
  tags                   = var.tags
}
