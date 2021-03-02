resource "azurerm_resource_group" "this" {
  name = var.rg_name
  location = var.rg_location
  tags = merge(
      var.additional_tags, 
      {
          Name = var.rg_name
      }
  )
}
