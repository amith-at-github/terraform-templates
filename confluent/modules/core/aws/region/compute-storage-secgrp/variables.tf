# Variables

variable "resource_name" {
  description = "The `Name` tag to use for provisioned services (e.g. confluent-platform-551)"
  type        = string
  default     = "Amith-demo-confluent-platform-62x"
}

variable "resource_owner" {
  description = "The `Owner` tag to use for provisioned services (e.g. Kirill Kulikov)"
  type        = string
  default     = "Amith Kumar Manjunath"
}

variable "resource_email" {
  description = "The `Email` tag to use for provisioned services (e.g. kirill.kulikov@confluent.io)"
  type        = string
  default     = "ammanjunath@confluent.io"
}

variable "resource_purpose" {
  description = "The `Purpose` tag to use for provisioned services (e.g. Testing CP 551)"
  type        = string
  default     = "Amith Testing CP 62x"
}


variable "aws_ipv4_cidr" {
  type = string
  #   default = "10.9.0.0/16"
  default = "10.9.0.0/16"
}


variable "ec2_ami_type" {
  description = "The type of AMI to run on EC2 Instances (ubuntu, rhel)"
  type        = string
  #default     = "ubuntu"
  default = "rhel"
}

variable "ssh_key_name" {
  description = "The key pair name (e.g. kirill-kulikov-ssh)"
  type        = string
  default     = "amith-aws-east1"
}

variable "ssh_public_key_path" {
  description = "The path to the SSH public key (e.g. ~/.ssh/Kirill-Kulikov-Confluent.pub)"
  type        = string
  default     = "~/.ssh/amith-aws-east1.pub"
}

variable "component" {
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

# variable "aws_vpc_id" {
#   type = string
#   default = ""
# }

# variable "aws_subnet_id" {
#   type = string
#   default = ""
# }

variable "created_aws_vpc_id" {
  type        = string
  description = "VPC id created in AWS."
}

variable "created_aws_private_subnets" {
  type        = list(any)
  description = "AWS created private Subnets in VPC."
}

variable "created_aws_public_subnets" {
  type        = list(any)
  description = "AWS created public Subnets in VPC."
}

