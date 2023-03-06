variable "confluent_cloud_environment_to_use" {}
variable "confluent_cloud_api_key" {}
variable "confluent_cloud_api_secret" {}

variable "date_updated" {}

variable "owner" {}
variable "owner_email" {}

variable "environment_name" {}
variable "purpose" {}
variable "aws_account_id" {
  description = "aws account id"
  type        = string
}

variable "ssh_key_name" {}

variable "ssh_public_key_path" {}


variable "components_r1" {
  description = "Map of component names to configuration"
  type        = map(any)
  default = {
    jumpbox = {
      instance_count     = 1
      instance_type      = "t3.medium"
      subnet_type_public = true
    },
    zookeeper = {
      instance_count = 1
      #instance_type  = "t3.medium"
      instance_type      = "t3.large"
      subnet_type_public = false
      #subnet_type_public = false
    },
    kafka = {
      instance_count     = 3
      instance_type      = "t3.large"
      subnet_type_public = false
    }
  }
}


variable "components_r2" {
  description = "Map of component names to configuration"
  type        = map(any)
}

variable "aws_region_details_r1" {
  description = "AWs regional details, cidr,zones, zone name etc"
  default = {
    region      = "us-east-1"
    cidr        = "10.19.0.0/16"
    zones       = ["use1-az1", "use1-az2", "use1-az5"]
    zones_names = ["us-east-1a", "us-east-1b", "us-east-1f"]
    # zones = {
    #   "use1-az1" = {
    #     public_subnet  = "10.1.1.0/24",
    #     private_subnet = "10.1.11.0/24",
    #   }
    #   "use1-az2" = {
    #     public_subnet  = "10.1.2.0/24",
    #     private_subnet = "10.1.12.0/24",
    #   }
    #   "use1-az5" = {
    #     public_subnet  = "10.1.5.0/24",
    #     private_subnet = "10.1.15.0/24",
    #   }
    # }
  }
}

variable "aws_region_details_r2" {
  description = "AWs regional details, cidr,zones, zone name etc"
  default = {
    region      = "us-west-2"
    cidr        = "10.21.0.0/16"
    zones       = ["usw2-az1", "usw2-az2", "usw2-az3"]
    zones_names = ["us-west-2a", "us-west-2b", "us-west-2c"]
    # zone   = "use1-az1"
    # zones = {
    #   "use1-az1" = {
    #     public_subnet  = "10.1.1.0/24",
    #     private_subnet = "10.1.11.0/24",
    #   }
    #   "use1-az2" = {
    #     public_subnet  = "10.1.2.0/24",
    #     private_subnet = "10.1.12.0/24",
    #   }
    #   "use1-az5" = {
    #     public_subnet  = "10.1.5.0/24",
    #     private_subnet = "10.1.15.0/24",
    #   }
    # }
  }
}