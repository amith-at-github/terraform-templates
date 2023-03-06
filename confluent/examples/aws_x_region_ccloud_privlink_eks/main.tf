module "aws_x_region_peering_with_ccloud_private_link_eks" {
  source                             = "../../modules/aws-scenarios/x-region-peering-with-ccloud-private-link"
  confluent_cloud_environment_to_use = var.confluent_cloud_environment_to_use
  confluent_cloud_api_key            = var.confluent_cloud_api_key
  confluent_cloud_api_secret         = var.confluent_cloud_api_secret
  date_updated                       = var.date_updated
  owner                              = var.owner
  owner_email                        = var.owner_email
  environment_name                   = var.environment_name
  purpose                            = var.purpose
  aws_account_id                     = var.aws_account_id
  ssh_key_name                       = var.ssh_key_name
  ssh_public_key_path                = var.ssh_public_key_path
  components_r1                      = var.components_both_regions
  components_r2                      = var.components_both_regions
  aws_region_details_r1              = var.aws_region_details_r1
  aws_region_details_r2              = var.aws_region_details_r2
}