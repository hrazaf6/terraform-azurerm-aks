module "networking" {
  source = "../modules/network"
  rg_create = true
  inline_subnet = false
  project = "cloudilm"
  rg_name = "aks_cluster"
  rg_location = "eastus"
  vnet_name = "aks_vnet"
  subnet_names = {
      "aks_subnet" = "172.30.0.0/24"
      "app_gateway" = "172.30.1.0/24"
  }
}


