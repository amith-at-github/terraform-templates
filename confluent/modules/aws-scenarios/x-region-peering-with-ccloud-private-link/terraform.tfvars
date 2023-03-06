confluent_cloud_environment_to_use = "env-5k6qn"
confluent_cloud_api_key            = "PSYJIC4J7BS27E5P"
confluent_cloud_api_secret         = "Og428TzSaYR9bEWzI9DMZxFaLqwsaPBK54z/DstXalGzfFFtL35Stmolh3KatdhG"
owner                              = "Amith K Manjunath "
owner_email                        = "ammanjunath@confluent.io"
environment_name                   = "Demo-NBCU-Amith"
purpose                            = "Amith NBCU Testing "
aws_account_id                     = "492737776546"
ssh_key_name                       = "amith-r1-tf-key"
ssh_public_key_path                = "~/.ssh/amith-aws-east1.pub"

components-r1 = {

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


components-r2 = {
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
