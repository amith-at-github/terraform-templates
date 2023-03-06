variable "created_aws_vpc_id" {
  type        = string
  description = "VPC id created in AWS."
}

variable "created_aws_private_subnets" {
  type        = list(any)
  description = "AWS created private Subnets in VPC."
}

variable "eks_cluster_name" {
  type        = string
  description = " Name of Eks cluster "
}