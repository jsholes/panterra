variable "hostname" {
  description = "The external IP address of the VM-Series instance"
  type = string
  default = "192.168.1.189"
}

variable "username" {
  description = "Username of the VM-Series administrator"
  type = string
  default = "admin"
}

variable "password" {
  description = "Password of the VM-Series administrator"
  type = string
  default = "NQ9mbXWC7JCfpFNpr"
}