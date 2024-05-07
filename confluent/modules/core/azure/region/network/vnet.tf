# Resource Group
resource "azurerm_resource_group" "my_rg" {
  location = var.resource_group_location
  name     = "${var.resource_group_name_prefix}-rg"
  tags = {
    owner_email = "ammanjunath@confluent.io"
  }
}

# Virtual Network
# Azure routes traffic between all subnets within a virtual network, by default. You can create your own routes to override Azure's default routing. Custom routes are helpful when, for example, you want to route traffic between subnets through a network virtual appliance (NVA).
# Subnet in Azure can span multiple AZ's or availabity Sets(Racks inside a single Dc)
resource "azurerm_virtual_network" "my_vnet" {
  name                = "${var.resource_group_name_prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
}

# subnet concept does not have to be publi or private
# AZ create dynamic internal ip for all VMs, public ip have to explictiyt creatd and attached to a nic
# NIC needs to be created and attached to VMs .. Nic can have internal ip or extenal public ip
# Subnet 2
resource "azurerm_subnet" "my_vnet_subnet_primary" {
  name                 = "${var.resource_group_name_prefix}-subnet-private"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Subnet 1
resource "azurerm_subnet" "my_vnet_subnet_secondary" {
  name                 = "${var.resource_group_name_prefix}-subnet-public"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}


resource "azurerm_network_security_group" "nsg_1" {
  name                = "${var.resource_group_name_prefix}-private-nsg"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.my_rg.name

  security_rule {
    name                       = "${var.resource_group_name_prefix}-inbound-rule-nsg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "primary_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.my_vnet_subnet_primary.id
  network_security_group_id = azurerm_network_security_group.nsg_1.id
}

resource "azurerm_public_ip" "my_public_ip" {
  for_each = local.service_instances_map
  # count               = length(local.service_instances_map)
  name                = each.value.subnet_type_public ? "${each.value.instance_name}-public-ip" : 0
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.my_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# AZ by default outbound internet connections are enabled for primary and secondary subnets. It does not need a NAT gateway, but having a NAT gateway has many advantages
resource "azurerm_network_interface" "my_nic" {
  for_each = local.service_instances_map
  name                = "nic-${each.value.instance_name}"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.my_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.my_vnet_subnet_primary.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = each.value.subnet_type_public ? azurerm_public_ip.my_public_ip["${each.value.instance_name}"].id : null
  }
}

resource "azurerm_virtual_machine" "my_vms" {
  # count = 3
  for_each = local.service_instances_map

  name                = each.value.instance_name
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.my_rg.name
  network_interface_ids = [azurerm_network_interface.my_nic[each.key].id]
  vm_size               = each.value.instance_type
  zones               = [ "${each.value.zone}"]
 
  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "storage-${each.value.instance_name}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = replace(each.value.instance_name, "_", "-") 
    admin_username = "azadminuser"
    # admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys  {
      # username   = "azadminuser"
      # use ssh-keygen -m PEM -t rsa -b 4096 to generate a key
      key_data =  file(var.component_ssh_key_file_path)
      path = "/home/azadminuser/.ssh/authorized_keys"
    }
  }
  tags = {
    environment = "staging"
  }
}

resource "local_file" "cp_ansible_basic" {
  filename = "cp-ansible-basic.yml"
  content  = templatefile("${path.module}/cp-ansible-basic.tftpl", 
    {
        ssh_key_file = var.component_ssh_key_file_path
        vms = local.vms
        components = var.component
    })
}

locals {
  zones = toset(["1","2","3"])
}

locals {
  service_instances = flatten([
    for svc_name, svc in var.component : [
      for i in range(0, svc.instance_count) : {
        instance_name = "${svc_name}-${i}"
        instance_type = svc.instance_type
        zone = (i<3) ? i+1 : (i%3)+1
        # data_volume   = svc.data_volume
        subnet_type_public = svc.subnet_type_public
        //subnet_id = "${svc.subnet_type_public ? element(module.aws-network.public_subnet.*.id, i) : element(module.aws-network.private_subnet.*.id, i)}"
        # subnet_id = "${svc.subnet_type_public ? element(var.created_aws_public_subnets, i) : element(var.created_aws_private_subnets, i)}"
        # vpc_security_group_id= "${svc.subnet_type_public ? aws_security_group.public_bastion_sgs.id : aws_security_group.priv_subnet_sgs.id}"
      }
    ]
  ])
  service_instances_map = {
    for inst in local.service_instances : inst.instance_name => inst
  }
}


locals  { 
    # "resource_group_name" = azurerm_resource_group.my_rg.name 
    # "vnet_name" = azurerm_virtual_network.my_vnet.name 
    # "subnet_public" = azurerm_subnet.my_vnet_subnet_public.name 
    # "subnet_private" = azurerm_subnet.my_vnet_subnet_private.name 
    vms = { for p in sort(keys(azurerm_virtual_machine.my_vms)) : p => ({
      "name" = azurerm_virtual_machine.my_vms[p].name
      "location" = azurerm_virtual_machine.my_vms[p].location
      "vm_size" = azurerm_virtual_machine.my_vms[p].vm_size
      "zones" = one(azurerm_virtual_machine.my_vms[p].zones)
      "private_ip_address" = azurerm_network_interface.my_nic[p].private_ip_address
      "public_ip_address" = azurerm_public_ip.my_public_ip[p].ip_address
  })}

  }
