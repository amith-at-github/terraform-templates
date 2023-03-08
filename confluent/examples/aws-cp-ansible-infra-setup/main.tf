module "aws_single_region_cp_ansible_infra_setup" {
  source                             = "../../modules/aws-scenarios/single-region-cp-ansible-infra-setup"
  date_updated                       = var.date_updated
  owner                              = var.owner
  owner_email                        = var.owner_email
  environment_name                   = var.environment_name
  purpose                            = var.purpose
  ssh_key_name                       = var.ssh_key_name
  ssh_public_key_path                = var.ssh_public_key_path
  components_r1                      = var.cp_components
  aws_region_details_r1              = var.aws_region_details_r1
}