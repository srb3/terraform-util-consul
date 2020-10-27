variable "aws_creds_file" {
  description = "The path to an aws credentials file"
  type        = string
}

variable "aws_profile" {
  description = "The name of an aws profile to use"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "The aws region to use"
  type        = string
  default     = "eu-west-1"
}

variable "aws_key_name" {
  description = "The name of an aws key pair to use for chef automate"
  type        = string
}

variable "tags" {
  description = "A set of tags to assign to the instances created by this module"
  type        = map(string)
  default     = {}
}

variable "ingress_cidrs" {
  description = "A list of CIDR's to use for allowing access to the chef_server vm"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ssh_user_private_key" {
  description = "The ssh private key used to access the chef_server proxy"
  type        = string
}

variable "consul_datacenter" {
  description = "The name of the datacenter to use for consul configuration"
  type        = string
  default     = "testdc1"
}

variable "consul_port" {
  description = "The port number to run the consul http port on"
  type        = string
  default     = "8500"
}

variable "consul_log_level" {
  description = "The log level to run consul at"
  type        = string
  default     = "debug"
}

variable "consul_populate_script" {
  description = "A script that is used to populate the consul server with test data"
  type        = string
  default     = <<EOF
    set -eux
    exec > /var/tmp/consul/consul_populate.log 2>&1
    sleep 10
    echo "before call ts $(date)"
    curl -XPUT http://localhost:8500/v1/kv/test-data -d '{"item1":"result1"}'
    echo "after call ts $(date)"
    touch /var/tmp/consul/consul.lock
    echo "after lock ts $(date)"
  EOF
}
