variable "aws_region_details" {
  description = "AWs regional details, cidr,zones, zone name etc"
}


variable "vpc_id" {
  description = "The VPC ID to private link to Confluent Cloud"
  type        = string
}


variable "ccloud_env_id" {
  description = "ccloud environemnt id"
  type        = string
}

variable "aws_account_id" {
  description = "aws account id"
  type        = string
}

variable "created_aws_private_subnets" {
  description = "AWS created private Subnets in VPC."
}


variable "created_priv_subnet_sgs" {
  description = "AWS created private subnet security groups."
}

