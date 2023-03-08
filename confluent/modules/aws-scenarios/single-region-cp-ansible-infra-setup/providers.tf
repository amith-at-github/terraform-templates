locals {
  mytags = {
    "tf_owner"         = var.owner
    "tf_owner_contact" = var.owner
    #"tf_provenance"    = "github.com/"
    "tf_workspace"     = terraform.workspace
    "tf_last_modified" = var.date_updated
    "Owner"            = var.owner
    "Environment"      = var.environment_name
    "owner_email"      = var.owner_email
    "purpose"          = var.purpose
  }

  # ignore_tax_prefixes = [
  #   "divvy",
  #   "confluent-infosec",
  #   "ics"
  # ]
}
#this is default module  and this shoudl not be passed to modules, but it is needed for providers inside modules
provider "aws" {
  region = "ca-central-1"
}

provider "aws" {
  alias  = "r1"
  region = var.aws_region_details_r1.region

  default_tags {
    tags = local.mytags
  }
}


# provider "confluent" {
#   alias            = "ccloud"
#   cloud_api_key    = var.confluent_cloud_api_key
#   cloud_api_secret = var.confluent_cloud_api_secret
# }

