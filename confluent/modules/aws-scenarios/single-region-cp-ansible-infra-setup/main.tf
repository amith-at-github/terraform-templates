module "aws_network_vpc_r1" {
  source = "../../core/aws/region/network"

  # AWS Settings
  aws_ipv4_cidr = var.aws_region_details_r1.cidr
  selected_azs  = var.aws_region_details_r1.zones

  providers = {
    aws = aws.r1
  }
}

module "aws_computer_storage_r1" {
  source                      = "../../core/aws/region/compute-storage-secgrp"
  created_aws_public_subnets  = module.aws_network_vpc_r1.created_aws_public_subnets
  created_aws_private_subnets = module.aws_network_vpc_r1.created_aws_private_subnets
  created_aws_vpc_id          = module.aws_network_vpc_r1.created_aws_vpc_id
 aws_ipv4_cidr = var.aws_region_details_r1.cidr
  # ec2_ami_type = "ubuntu"
  ec2_ami_type = "rhel"

  # SSH Key
  ssh_key_name        = var.ssh_key_name
  ssh_public_key_path = var.ssh_public_key_path

  component = var.components_r1


  providers = {
    aws = aws.r1
  }

}