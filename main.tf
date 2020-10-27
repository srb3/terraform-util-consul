locals {
  dna = {
    "consul_wrapper" = {
      "linux_url"           = var.linux_url,
      "windows_url"         = var.windows_url,
      "linux_bin_path"      = var.linux_bin_path,
      "windows_bin_path"    = var.windows_bin_path,
      "linux_data_path"     = var.linux_data_path,
      "windows_data_path"   = var.windows_data_path,
      "linux_var_path"      = var.linux_var_path,
      "windows_var_path"    = var.windows_var_path,
      "linux_config_path"   = var.linux_config_path,
      "windows_config_path" = var.windows_config_path,
      "bind"                = var.bind,
      "server"              = var.server,
      "bootstrap_expect"    = var.bootstrap_expect,
      "datacenter"          = var.datacenter,
      "script"              = var.populate_script,
      "script_lock_file"    = var.populate_script_lock_file,
      "port"                = var.port,
      "log_level"           = var.log_level
    }
  }
}

module "consul_build" {
  source           = "srb3/policyfile/chef"
  version          = "0.13.2"
  ip               = var.ip
  dna              = local.dna
  cookbooks        = var.cookbooks
  runlist          = var.runlist
  user_name        = var.user_name
  user_pass        = var.user_pass
  user_private_key = var.user_private_key
  policyfile_name  = var.policyfile_name
  timeout          = var.timeout
  system_type      = var.system_type
  linux_tmp_path   = var.linux_tmp_path
}
