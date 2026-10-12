module "aws-x-region-vpc-tgw" {
  source                             = "../../modules/aws-scenarios/x-region-vpc-tgw-with-ec2"
  date_updated                       = var.date_updated
  owner                              = var.owner
  owner_email                        = var.owner_email
  environment_name                   = var.environment_name
  purpose                            = var.purpose
  ssh_key_name                       = var.ssh_key_name
  ssh_public_key_path                = var.ssh_public_key_path
  components_r1                      = var.components_both_regions
  components_r2                      = var.components_both_regions
  aws_region_details_r1              = var.aws_region_details_r1
  aws_region_details_r2              = var.aws_region_details_r2

  tgw_r1_asn                         = var.tgw_r1_asn # make sure this is different for both region
  tgw_r2_asn                         = var.tgw_r2_asn # make sure this is different for both region
}