output "created_aws_vpc_id_r1" {
  value       = module.aws_x_region_peering_with_ccloud_private_link_eks.created_aws_vpc_id_r1
  description = "VPC id created in AWS."
}

output "created_aws_private_subnets_r1" {
  value       = module.aws_x_region_peering_with_ccloud_private_link_eks.created_aws_private_subnets_r1
  description = "AWS created private Subnets in VPC."
}

output "created_aws_public_subnets_r1" {
  value       = module.aws_x_region_peering_with_ccloud_private_link_eks.created_aws_public_subnets_r1
  description = "AWS created public Subnets in VPC."
}
output "created_subnet_instance_details_r1" {
  value = module.aws_x_region_peering_with_ccloud_private_link_eks.created_subnet_instance_details_r1
}
output "ec2_instance_details_r1" {
  value       = module.aws_x_region_peering_with_ccloud_private_link_eks.ec2_instance_details_r1
  description = "EC2 Instance details"

}

output "created_aws_vpc_id_r2" {
  value       = module.aws_x_region_peering_with_ccloud_private_link_eks.created_aws_vpc_id_r2
  description = "VPC id created in AWS."
}

output "created_aws_private_subnets_r2" {
  value       = module.aws_x_region_peering_with_ccloud_private_link_eks.created_aws_private_subnets_r2
  description = "AWS created private Subnets in VPC."
}

output "created_aws_public_subnets_r2" {
  value       = module.aws_x_region_peering_with_ccloud_private_link_eks.created_aws_public_subnets_r2
  description = "AWS created public Subnets in VPC."
}


output "created_subnet_instance_details_r2" {
  value = module.aws_x_region_peering_with_ccloud_private_link_eks.created_subnet_instance_details_r2
}

output "ec2_instance_details_r2" {
  value       = module.aws_x_region_peering_with_ccloud_private_link_eks.ec2_instance_details_r2
  description = "EC2 Instance details"

}

output "created_aws_public_route_table_r1" {
  value       = module.aws_x_region_peering_with_ccloud_private_link_eks.created_aws_public_route_table_r1
  description = "AWS created public route table in r1 VPC."
}

output "created_aws_private_route_table_r1" {
  value       = module.aws_x_region_peering_with_ccloud_private_link_eks.created_aws_private_route_table_r1
  description = "AWS created private route table in r1 VPC."
}

output "created_aws_public_route_table_r2" {
  value       = module.aws_x_region_peering_with_ccloud_private_link_eks.created_aws_public_route_table_r2
  description = "AWS created public  route table in r2 VPC."
}

output "created_aws_private_route_table_r2" {
  value       = module.aws_x_region_peering_with_ccloud_private_link_eks.created_aws_private_route_table_r2
  description = "AWS created private  route table in r2  VPC."
}