terraform {
  required_providers {
    azurerm={
      source="hashicorp/azurerm"
      version = ">=2.26"
    }
  }
  required_version = ">= 0.14.9"
}


provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "first" {

  name = "FIRST_TERRAFORM"
  location = "Central India"
}

resource "azurerm_container_group" "first_container" {
   
   name                =  "webapi"
   location            = azurerm_resource_group.first.location
   resource_group_name =  azurerm_resource_group.first.name

   ip_address_type        = "public"
   dns_name_label         = "sakshamjha1910ap"
   os_type                = "Linux"
  
   container {
      name = "webapi"
      image = "sakshamjha1910/webapi"
      cpu = "1"
      memory = "1"

      ports {
        port ="80"
        protocol = "TCP"
      }
      
     
   }
   
}

resource "azurerm_network_security_group" "nsg1" {

  name = "Network1"
  location = azurerm_resource_group.first.location
  resource_group_name = azurerm_resource_group.first.name
}

resource "azurerm_network_ddos_protection_plan" "plan_first" {
  
  name = "Plan1"
  location = azurerm_resource_group.first.location
  resource_group_name = azurerm_resource_group.first.name
}

resource "azurerm_virtual_network" "vn1" {
  
  name ="Vnet1"
  location = azurerm_resource_group.first.location
  resource_group_name = azurerm_resource_group.first.name
  address_space = ["10.0.0.0/24"]
  dns_servers = ["10.0.0.4","10.0.0.5"]

  ddos_protection_plan {
    id = azurerm_network_ddos_protection_plan.plan_first.id
    enable = true
  }

  subnet {
    name = "Subnet1"
    address_prefix = "10.0.0.0/26"
    security_group = azurerm_network_security_group.nsg1.id
  }
}
