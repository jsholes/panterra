variable "panos_hostname" {
  description = "The external IP address of the VM-Series instance"
  type = "string"
  default = "192.168.1.60"
}

variable "panos_username" {
  description = "Username of the VM-Series administrator"
  type = "string"
  default = "admin"
}

variable "panos_password" {
  description = "Password of the VM-Series administrator"
  type = "string"
  default = "NQ9mbXWC7JCfpFNp"
}