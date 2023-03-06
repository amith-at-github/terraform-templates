output "created_aws_vpc_id_r1" {
  value       = module.aws_network_vpc_r1.created_aws_vpc_id
  description = "VPC id created in AWS."
}

output "created_aws_private_subnets_r1" {
  value       = module.aws_network_vpc_r1.created_aws_private_subnets
  description = "AWS created private Subnets in VPC."
}

output "created_aws_public_subnets_r1" {
  value       = module.aws_network_vpc_r1.created_aws_public_subnets
  description = "AWS created public Subnets in VPC."
}
output "created_subnet_instance_details_r1" {
  value = module.aws_network_vpc_r1.created_subnet_instance_details
}
output "ec2_instance_details_r1" {
  value       = module.aws_computer_storage_r1.ec2_instance_details
  description = "EC2 Instance details"

}

output "created_aws_vpc_id_r2" {
  value       = module.aws_network_vpc_r2.created_aws_vpc_id
  description = "VPC id created in AWS."
}

output "created_aws_private_subnets_r2" {
  value       = module.aws_network_vpc_r2.created_aws_private_subnets
  description = "AWS created private Subnets in VPC."
}

output "created_aws_public_subnets_r2" {
  value       = module.aws_network_vpc_r2.created_aws_public_subnets
  description = "AWS created public Subnets in VPC."
}


output "created_subnet_instance_details_r2" {
  value = module.aws_network_vpc_r2.created_subnet_instance_details
}

output "ec2_instance_details_r2" {
  value       = module.aws_computer_storage_r2.ec2_instance_details
  description = "EC2 Instance details"

}

output "created_aws_public_route_table_r1" {
  value       = module.aws_network_vpc_r1.created_aws_public_route_table
  description = "AWS created public route table in r1 VPC."
}

output "created_aws_private_route_table_r1" {
  value       = module.aws_network_vpc_r1.created_aws_private_route_table
  description = "AWS created private route table in r1 VPC."
}

output "created_aws_public_route_table_r2" {
  value       = module.aws_network_vpc_r2.created_aws_public_route_table
  description = "AWS created public  route table in r2 VPC."
}

output "created_aws_private_route_table_r2" {
  value       = module.aws_network_vpc_r2.created_aws_private_route_table
  description = "AWS created private  route table in r2  VPC."
}

