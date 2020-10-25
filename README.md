# Overview
This terraform module deploys consul in a stand-alone server configuration. The main use case for this module is as a data source collector for other terraform modules to utilise.
The idea is to remove the need for using external data sources with terrafrom modules and replace them with data collected from consuls key value store. As such one of the options
this module takes is a populate scritp. Pass this variable a value of a powershell or bash script that populates the consul kv store with one or more variables. In order for this to
work the computer that is running the terraform needs to have access to the consul http port (8500 by default).

### Supported platform families:
 * Debian
 * SLES
 * RHEL
 * Windows

## Usage
#### Example: Basic usage
The following example connects to a server, installs and starts the consul service on that server (a chef server in this case), passes through a script to populate consul
with chef server details that are used as data sources for module output
and 
```hcl

consul_populate_script = templatefile("${path.module}/templates/consul_populate_script", {
...
...
...
})

module "consul" {
  source                    = "srb3/consul/util"
  version                   = "0.13.0"
  ip                        = var.ip
  user_name                 = var.ssh_user_name
  user_private_key          = var.ssh_user_private_key
  populate_script           = local.consul_populate_script
  datacenter                = var.consul_datacenter
  depends_on                = [module.chef_server_build]
}
    
provider "consul" {
  address = "${var.ip}:8500"
}
        
data "consul_keys" "chef_server_details" {
  depends_on = [module.consul]
  datacenter = var.consul_datacenter
  key {
    name = "data"
    path = "chef-server-details"
  }
}

locals {
  chef_server_details = jsondecode(data.consul_keys.chef_server_details.var.data)
}

output "client_pem" {
  value = local.chef_server_details["client_pem"]
}
  
```
