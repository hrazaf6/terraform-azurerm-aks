variable "rg_name" {
  type = string
  description = "Name of the Resource Group"
}

variable "rg_location" {
  type = string
  description = "Location of the Resource Group"
}

variable "additional_tags" {
  type = map(any)
  description = "Additional tag that need to merged"
  default = {}
}