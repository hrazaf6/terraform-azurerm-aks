variable "project" {
  type = string
  description = "Project Name"
  default = ""
}

variable "environment" {
  type = string
  description = "Environment Name"
  default = "dev"
}

variable "rg_create" {
  type = bool
  description = "If you want to create the Resource Group"
  default = false
}

variable "rg_name" {
  type = string
  description = "Name the Resource Group"
}

variable "rg_location" {
  type = string
  description = "Location of the Resource Group"
}

variable "vnet_name" {
  type = string
  description = "Name of the Virtual Network"
}

variable "vnet_address_space" {
  type = list(string)
  description = "The address space that is used the virtual network"
  default = [ "172.30.0.0/16" ]
}

variable "bgp_community" {
  type = string
  description = "The BGP community attribute in format <as-number>:<community-value>. The as-number segment is the Microsoft ASN, which is always 12076 for now."
  default = null
}

variable "enable_ddos_protection_plan" {
  type = bool
  description = "If DDOS Protection plan need to get enabled"
  default = false
}

variable "ddos_id" {
  type = string
  description = "The ID of DDoS Protection Plan"
  default = null
}

variable "dns_servers" {
  type = list(string)
  description = "List of IP addresses of DNS servers"
  default = []
}

variable "inline_subnet" {
  type = bool
  description = "Create the Subnet with inline block"
  default = true
}

variable "subnet_names" {
  type = map(any)
  description = "Subnet COnfiguration name with address_prefix"
  default = {}
}

variable "vm_protection_enabled" {
  type = bool
  description = "Whether to enable VM protection for all the subnets in this Virtual Network"
  default = false
}

variable "additional_tags" {
  type = map(any)
  description = "Additional tag that need to merged"
  default = {}
}

variable "enable_delegation" {
  type = bool
  description = "Enable the Delegation"
  default = false
}

variable "delegation_name" {
  type = string
  description = "Provide the Delegation Name"
  default = null
}

variable "name_of_service_delegation" {
  type = list(string)
  description = "List of name of service to delegate to"
  default = []
}

variable "service_delegation_actions" {
  type = list(string)
  description = "List of Actions which should be delecated"
  default = []
}

variable "enable_enforce_private_link_endpoint_network_policies" {
  type = bool
  description = "Enable or Disable network policies for the private link endpoint on the subnet"
  default = false
}

variable "enable_enforce_private_link_service_network_policies" {
  type = bool
  description = "Enable or Disable network policies for the private link service on the subnet."
  default = false
}

variable "service_endpoints" {
  type = list(string)
  description = "The list of Service endpoints to associate with the subnet"
  default = []
}

variable "service_endpoint_policy_ids" {
  type = list(string)
  description = "The list of IDs of Service Endpoint Policies to associate with the subnet."
  default = null
}

############################################################################################################################

locals {
  vnet_name = format("%s-%s-%s", var.project, var.environment, var.vnet_name)
  rg_name = format("%s-%s-%s", var.project, var.environment, var.rg_name)
  subnet_names = { for subnet, prefix in var.subnet_names: format("%s-%s-%s-%s", var.project, var.environment, var.vnet_name, subnet) => prefix }
}

