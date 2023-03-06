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

  # ec2_ami_type = "ubuntu"
  ec2_ami_type = "rhel"

  # SSH Key
  ssh_key_name        = var.ssh_key_name
  ssh_public_key_path = var.ssh_public_key_path

  component = var.components_r2


  providers = {
    aws = aws.r1
  }
  # depends_on = [
  #   module.aws-network-vpc-r1
  # ]
}

module "aws_eks_clstr_r1" {
  source = "../../core/aws/region/eks"

  # Cluster Name
  eks_cluster_name = "DEMO-eks-r1-${var.environment_name}"

  created_aws_private_subnets = module.aws_network_vpc_r1.created_aws_private_subnets
  created_aws_vpc_id          = module.aws_network_vpc_r1.created_aws_vpc_id

  providers = {
    aws = aws.r1
  }
}

module "aws_dedicated_ccloud_clstr_privatelink_r1" {
  source             = "../../core/aws/region/ccloud/network/private-link"
  aws_region_details = var.aws_region_details_r1
  vpc_id             = module.aws_network_vpc_r1.created_aws_vpc_id

  created_aws_private_subnets = module.aws_network_vpc_r1.created_aws_private_subnets
  ccloud_env_id               = var.confluent_cloud_environment_to_use
  aws_account_id              = var.aws_account_id
  created_priv_subnet_sgs     = module.aws_computer_storage_r1.created_aws_security_group_priv_subnet_sgs

  providers = {
    aws       = aws.r1
    confluent = confluent.ccloud
  }
  depends_on = [
    module.aws_network_vpc_r1
  ]
}
