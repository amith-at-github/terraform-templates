output "created_az_resource_group_name" {
  description = "The name of the created resource group."
  value       = azurerm_resource_group.my_rg.name
}

output "created_az_virtual_network_name" {
  description = "The name of the created virtual network."
  value       = azurerm_virtual_network.my_vnet.name
}

output "created_az_my_vnet_subnet_primary" {
  description = "The name of the created subnet 1."
  value       = azurerm_subnet.my_vnet_subnet_primary.name 
}

output "created_az_my_vnet_subnet_secondary" {
  description = "The name of the created subnet 1."
  value       = azurerm_subnet.my_vnet_subnet_secondary.name
}

output "created_az_my_vnet_resources" {
  description = "The name of the created subnet 1."
  # value       = azurerm_virtual_machine.my_vms.name
  value = { 
    "resource_group_name" = azurerm_resource_group.my_rg.name 
    "vnet_name" = azurerm_virtual_network.my_vnet.name 
    "subnet_primary" = azurerm_subnet.my_vnet_subnet_secondary.name 
    "subnet_secondary" = azurerm_subnet.my_vnet_subnet_primary.name 
    "Vms" = { for p in sort(keys(azurerm_virtual_machine.my_vms)) : p => ({
      "name" = azurerm_virtual_machine.my_vms[p].name
      "location" = azurerm_virtual_machine.my_vms[p].location
      "vm_size" = azurerm_virtual_machine.my_vms[p].vm_size
      "zones" = one(azurerm_virtual_machine.my_vms[p].zones)
      "private_ip_address" = azurerm_network_interface.my_nic[p].private_ip_address
      "public_ip_address" = azurerm_public_ip.my_public_ip[p].ip_address
  })}

  }

}

# output "created_az_my_cp_ansible_resources" {
#   description = "The name of the created virtual network."
#   value       = {
#     for p in var.component: p => ({
#       "name": p

#     })

#     }
   
#   }


# output "created_az_created_subnet_instance_details" {
#   description = "subnet dteails details"
#   value       = local.subnet_instances_map
# }
