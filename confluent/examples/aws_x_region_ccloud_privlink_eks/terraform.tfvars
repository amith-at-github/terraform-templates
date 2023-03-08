# confluent_cloud_environment_to_use = "<CCLOUD_ENVIRONMET_FOR_KAFKA_CLUSTERS>-<SCENARIO-WHERE-NEW-ENV_CANNOT_BE_CREATED>"
# confluent_cloud_api_key            = "<CCLOUD_API_KEY>"
# confluent_cloud_api_secret         = "<CCLOUD_API_SECRET>"
# owner                              = "<NAME>"
# owner_email                        = "<EMAIL>"
# environment_name                   = "<ENV_NAME>-<USED-BY-RESOURCES-AND-TAGS-FOR-DESCRIPTION""
# purpose                            = "<PURPOSE>"
# aws_account_id                     = "<AWS-ACCT-ID>-<ON-RIGHT-TOP-OF-AWS_LOGIN>"
# ssh_key_name                       = "<SOMETHING>-key-<JUST-A-NAME>"
# ssh_public_key_path                = "~/.ssh/<SOMETHING>.pub"


components_both_regions = {

  jumpbox = {
    instance_count = 1
    # instance_type  = "t3.micro"
    instance_type      = "t3.medium"
    subnet_type_public = true
  }
  connect = {
    instance_count = 1
    # instance_type  = "t3.micro"
    instance_type      = "t3.medium"
    subnet_type_public = false
  }
}

aws_region_details_r1 = {
  region      = "us-east-1"
  cidr        = "10.19.0.0/16"
  zones       = ["use1-az1", "use1-az2", "use1-az5"]
  zones_names = ["us-east-1a", "us-east-1b", "us-east-1f"]
}

aws_region_details_r2 = {
  region      = "us-west-2"
  cidr        = "10.21.0.0/16"
  zones       = ["usw2-az1", "usw2-az2", "usw2-az3"]
  zones_names = ["us-west-2a", "us-west-2b", "us-west-2c"]
}
