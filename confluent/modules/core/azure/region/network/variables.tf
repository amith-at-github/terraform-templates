variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "amith-demo1"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "component_ssh_key_file_path" {
  type        = string
  default     = "~/.ssh/amith-azure"
  description = "Path where ssh key file is stored in local tf environment"
}

variable "component" {
  description = "Map of component names to configuration"
  type        = map(any)
  default = {
    jumpbox = {
      instance_count     = 1
      instance_type      = "Standard_A4_v2"
      subnet_type_public = true
    },
    zookeeper = {
      instance_count     = 3
      instance_type      = "Standard_D1_v2"
     # instance_type      = "Standard_A4_v2"
      subnet_type_public = true
    },
    kafka_broker = {
      instance_count     = 3
      instance_type      = "Standard_D1_v2"
      #instance_type      = "Standard_A4_v2"
      subnet_type_public = true
    },
    control_center = {
      instance_count     = 1
      instance_type      = "Standard_D1_v2"
       #instance_type      = "Standard_A4_v2"
      subnet_type_public = true
    }
    # schema_registry = {
    #   instance_count     = 1
    #   instance_type      = "Standard_A2_v2"
    #   subnet_type_public = false
    # },
    # kafka_connect = {
    #   instance_count     = 1
    #   instance_type      = "Standard_A4_v2"
    #   subnet_type_public = false
    # },
    # kafka_rest = {
    #   instance_count     = 1
    #   instance_type      = "Standard_A4_v2"
    #   subnet_type_public = false
    # },
    # ksql = {
    #   instance_count     = 1
    #   instance_type      = "Standard_D4_v2"
    #   subnet_type_public = false
    # }
  }
}
