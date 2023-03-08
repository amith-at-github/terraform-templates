output "created_aws_vpc_id_r1" {
  value       = module.aws_single_region_cp_ansible_infra_setup.created_aws_vpc_id_r1
  description = "VPC id created in AWS."
}

output "created_aws_private_subnets_r1" {
  value       = module.aws_single_region_cp_ansible_infra_setup.created_aws_private_subnets_r1
  description = "AWS created private Subnets in VPC."
}

output "created_aws_public_subnets_r1" {
  value       = module.aws_single_region_cp_ansible_infra_setup.created_aws_public_subnets_r1
  description = "AWS created public Subnets in VPC."
}
output "created_subnet_instance_details_r1" {
  value = module.aws_single_region_cp_ansible_infra_setup.created_subnet_instance_details_r1
}
output "ec2_instance_details_r1" {
  value       = module.aws_single_region_cp_ansible_infra_setup.ec2_instance_details_r1
  description = "EC2 Instance details"

}
output "created_aws_public_route_table_r1" {
  value       = module.aws_single_region_cp_ansible_infra_setup.created_aws_public_route_table_r1
  description = "AWS created public route table in r1 VPC."
}

output "created_aws_private_route_table_r1" {
  value       = module.aws_single_region_cp_ansible_infra_setup.created_aws_private_route_table_r1
  description = "AWS created private route table in r1 VPC."
}

