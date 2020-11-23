################## connection #####################

variable "ip" {
  description = "The ip address where chef-solo will run"
  type        = string
}

variable "user_name" {
  description = "The ssh or winrm user name used to access the ip addresses provided"
  type        = string
}

variable "user_pass" {
  description = "The ssh or winrm user password used to access the ip addresses (either user_pass or user_private_key needs to be set)"
  type        = string
  default     = ""
}

variable "user_private_key" {
  description = "The ssh user key used to access the ip addresses (either user_pass or user_private_key needs to be set)"
  type        = string
  default     = ""
}

variable "timeout" {
  description = "The timeout to wait for the connection to become available. Should be provided as a string like 30s or 5m, Defaults to 5 minutes."
  type        = string
  default     = "5m"
}

variable "system_type" {
  description = "The system type linux or windows"
  type        = string
  default     = "linux"
}

variable "runlist" {
  description = "The runlist to pass through to the auto generated policyfile"
  type        = list
  default     = ["consul_wrapper::default"]
}

variable "cookbooks" {
  description = "The cookbook names, locations and versions to pass through to the auto generated policyfile"
  default = {
    "consul_wrapper" = "github: 'srb3/consul_wrapper', tag: 'v0.1.8'"
  }
}

variable "policyfile_name" {
  description = "The name to give the auto generated policyfile (used if the policyfile variable is set to an empty string"
  type        = string
  default     = "consul"
}

########### cookbook attributes ##################

variable "linux_url" {
  description = "The url to the consul linux x86 binary zip file"
  type        = string
  default     = "https://releases.hashicorp.com/consul/1.8.4/consul_1.8.4_linux_amd64.zip"
}

variable "windows_url" {
  description = "The url to the consul windows x86 binary zip file"
  type        = string
  default     = "https://releases.hashicorp.com/consul/1.8.4/consul_1.8.4_windows_amd64.zip"
}

variable "linux_bin_path" {
  description = "The path where the linux binary will be installed"
  type        = string
  default     = "/opt/consul/bin"
}

variable "windows_bin_path" {
  description = "The path where the windows binary will be installed"
  type        = string
  default     = "C:\\consul\\bin"
}

variable "linux_data_path" {
  description = "The path to store consuls data files on linux"
  type        = string
  default     = "/opt/consul/data"
}

variable "windows_data_path" {
  description = "The path to store consuls data files on windows"
  type        = string
  default     = "C:/consul/data"
}

variable "linux_var_path" {
  description = "The path to store consuls log files on linux"
  type        = string
  default     = "/opt/consul/var"
}

variable "windows_var_path" {
  description = "The path to store consuls log files on windows"
  type        = string
  default     = "C:\\consul\\var"
}

variable "linux_config_path" {
  description = "The path to store consuls config files on linux"
  type        = string
  default     = "/opt/consul/conf"
}

variable "windows_config_path" {
  description = "The path to store consuls config files on windows"
  type        = string
  default     = "C:\\consul\\conf"
}

variable "bind" {
  description = "The address for consul to bind to"
  type        = string
  default     = "0.0.0.0"
}

variable "server" {
  description = "Should we run consul in server mode"
  type        = bool
  default     = true
}

variable "bootstrap_expect" {
  description = "The number of server to expect in the bootstrap phase"
  type        = number
  default     = 1
}

variable "datacenter" {
  description = "The name of the datacenter to use for this consul instance"
  type        = string
  default     = "dc1"
}

variable "populate_script" {
  description = "A script to execute on the consul system to populate the consul kv store"
  type        = string
  default     = ""
}

variable "populate_script_lock_file" {
  description = "A lock file to create to make the populate script only run once"
  type        = string
  default     = ""
}

variable "linux_tmp_path" {
  description = "The location of a temp directory to store install scripts on"
  type        = string
  default     = "/var/tmp"
}

variable "port" {
  description = "The port number to use for consul http"
  type        = string
  default     = "8500"
}

variable "log_level" {
  description = "The log level to run the consul service at"
  type        = string
  default     = "info"
}
