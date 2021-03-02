locals {
  aks_name = format("%s-%s-%s", var.project, var.environment, var.aks_name)
}