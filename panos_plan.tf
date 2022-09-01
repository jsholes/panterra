terraform {
  required_providers {
    panos = {
      source = "PaloAltoNetworks/panos"
      version = "1.10.3"
    }
  }
}

provider "panos" {
    hostname = "${var.panos_hostname}"
    username = "${var.panos_username}"
    password = "${var.panos_password}"
}

resource "panos_ethernet_interface" "eth3" {
    name = "ethernet1/3"
    vsys = "vsys1"
    mode = "layer3"
    enable_dhcp = true
    create_dhcp_default_route = true
}

resource "panos_ethernet_interface" "eth4" {
    name = "ethernet1/4"
    vsys = "vsys1"
    mode = "layer3"
    enable_dhcp = true
}

resource "panos_virtual_router" "vr" {
    name = "default"
    interfaces = [
        "${panos_ethernet_interface.eth3.name}",
        "${panos_ethernet_interface.eth4.name}"
    ]
}

resource "panos_zone" "int" {
    name = "L3-trust"
    mode = "layer3"
    interfaces = ["${panos_ethernet_interface.eth3.name}"]
}

resource "panos_zone" "ext" {
    name = "L3-untrust"
    mode = "layer3"
    interfaces = ["${panos_ethernet_interface.eth4.name}"]
}

