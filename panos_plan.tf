terraform {
  required_providers {
    panos = {
      source = "PaloAltoNetworks/panos"
      version = "1.10.3"
    }
  }
}

provider "panos" {
    hostname = "${var.hostname}"
    username = "${var.username}"
    password = "${var.password}"
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

resource "panos_address_object" "wp" {
    name = "wordpress server"
    description = "Internal server"
    value = "10.1.23.45"
}

resource "panos_security_rule_group" "policy" {
    rule {
        name = "Wordpress Traffic"
        source_zones = ["${panos_zone.ext.name}"]
        source_addresses = ["any"]
        source_users = ["any"]
        hip_profiles = ["any"]
        destination_zones = ["${panos_zone.int.name}"]
        destination_addresses = ["any"]
        applications = ["web-browsing"]
        services = ["application-default"]
        categories = ["any"]
        action = "allow"
    }
    rule {
        name = "Outbound"
        source_zones = ["${panos_zone.int.name}"]
        source_addresses = ["any"]
        source_users = ["any"]
        hip_profiles = ["any"]
        destination_zones = ["${panos_zone.ext.name}"]
        destination_addresses = ["any"]
        applications = ["any"]
        services = ["application-default"]
        categories = ["any"]
        action = "allow"
    }
    rule {
        name = "Default Deny"
        source_zones = ["any"]
        source_addresses = ["any"]
        source_users = ["any"]
        hip_profiles = ["any"]
        destination_zones = ["any"]
        destination_addresses = ["any"]
        applications = ["any"]
        services = ["application-default"]
        categories = ["any"]
        action = "deny"
    }
}