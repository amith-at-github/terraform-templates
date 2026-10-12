output "created_aws_vpc_id_r1" {
  value       = module.aws-x-region-vpc-tgw.created_aws_vpc_id_r1
  description = "VPC id created in AWS."
}

output "created_aws_private_subnets_r1" {
  value       = module.aws-x-region-vpc-tgw.created_aws_private_subnets_r1
  description = "AWS created private Subnets in VPC."
}

output "created_aws_public_subnets_r1" {
  value       = module.aws-x-region-vpc-tgw.created_aws_public_subnets_r1
  description = "AWS created public Subnets in VPC."
}
output "created_subnet_instance_details_r1" {
  value = module.aws-x-region-vpc-tgw.created_subnet_instance_details_r1
}
output "ec2_instance_details_r1" {
  value       = module.aws-x-region-vpc-tgw.ec2_instance_details_r1
  description = "EC2 Instance details"

}
output "created_aws_public_route_table_r1" {
  value       = module.aws-x-region-vpc-tgw.created_aws_public_route_table_r1
  description = "AWS created public route table in r1 VPC."
}

output "created_aws_private_route_table_r1" {
  value       = module.aws-x-region-vpc-tgw.created_aws_private_route_table_r1
  description = "AWS created private route table in r1 VPC."
}



output "created_aws_vpc_id_r2" {
  value       = module.aws-x-region-vpc-tgw.created_aws_vpc_id_r2
  description = "VPC id created in AWS."
}

output "created_aws_private_subnets_r2" {
  value       = module.aws-x-region-vpc-tgw.created_aws_private_subnets_r2
  description = "AWS created private Subnets in VPC."
}

output "created_aws_public_subnets_r2" {
  value       = module.aws-x-region-vpc-tgw.created_aws_public_subnets_r2
  description = "AWS created public Subnets in VPC."
}
output "created_subnet_instance_details_r2" {
  value = module.aws-x-region-vpc-tgw.created_subnet_instance_details_r2
}
output "ec2_instance_details_r2" {
  value       = module.aws-x-region-vpc-tgw.ec2_instance_details_r2
  description = "EC2 Instance details"

}
output "created_aws_public_route_table_r2" {
  value       = module.aws-x-region-vpc-tgw.created_aws_public_route_table_r2
  description = "AWS created public route table in r2 VPC."
}

output "created_aws_private_route_table_r2" {
  value       = module.aws-x-region-vpc-tgw.created_aws_private_route_table_r2
  description = "AWS created private route table in r2 VPC."
}



output "tgw_r1_id" {
  value       = module.aws-x-region-vpc-tgw.tgw_r1_id
  description = "Transit Gateway ID in region r1."
}

output "tgw_r2_id" {
  value       = module.aws-x-region-vpc-tgw.tgw_r2_id
  description = "Transit Gateway ID in region r2."
}

output "tgw_peering_attachment_id" {
  value       = module.aws-x-region-vpc-tgw.tgw_peering_attachment_id
  description = "Transit Gateway peering attachment ID (r1 -> r2)."
}

output "tgw_peering_attachment_state" {
  value       = module.aws-x-region-vpc-tgw.tgw_peering_attachment_state
  description = "State of the accepted peering attachment on the r2 side."
}

output "tgw_attachment_r1_id" {
  value       = module.aws-x-region-vpc-tgw.tgw_attachment_r1_id
  description = "Transit Gateway VPC attachment ID for r1 private subnets."
}

output "tgw_attachment_r2_id" {
  value       = module.aws-x-region-vpc-tgw.tgw_attachment_r2_id
  description = "Transit Gateway VPC attachment ID for r2 private subnets."
}
