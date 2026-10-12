# owner                              = "<NAME>"
# owner_email                        = "<EMAIL>"
# environment_name                   = "<ENV_NAME>-<USED-BY-RESOURCES-AND-TAGS-FOR-DESCRIPTION""
# purpose                            = "<PURPOSE>"
# ssh_key_name                       = "<SOMETHING>-key-<JUST-A-NAME>"
# ssh_public_key_path                = "~/.ssh/<SOMETHING>.pub"

owner                              = "Amith"
owner_email                        = "ammanjunath@confleunt.io"
environment_name                   = "cp-poc-x-region-tgw-clusterlink"
purpose                            = "poc"
ssh_key_name                       = "aws-amith-global-ssh-key"
ssh_public_key_path                = "~/.ssh/aws-amith-global-ssh-key.pub"


tgw_r1_asn                            = 64512
tgw_r2_asn                            = 64513


# run this command to check and populate this table
# aws ec2 describe-availability-zones --region us-west-2 --output table --query "AvailabilityZones[*].{Zone: ZoneName, ZoneId: ZoneId, State: State}"

aws_region_details_r1 = {

  # cidr        = "10.101.0.0/16"
  # region      = "us-west-1"
  # zones       = ["usw1-az1", "usw1-az3"]
  # zones_names = ["us-west-1a", "us-west-1c"]
 

  cidr        = "10.101.0.0/16"
  region      = "us-east-1"
  zones       = ["use1-az2", "use1-az4", "use1-az6"]
  zones_names = ["us-east-1a", "us-east-1b", "us-east-1f"]
  
  # cidr        = "10.111.0.0/16"
  # region      = "eu-west-1"
  # zones       = ["euw1-az1", "euw1-az2", "euw1-az3"]
  # zones_names = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

}

aws_region_details_r2 = {
  # cidr        = "10.201.0.0/16"
  # region      = "us-west-2"
  # zones       = ["usw2-az2", "usw2-az1", "usw2-az3"]
  # zones_names = ["us-west-2a", "us-west-2b", "us-west-2c"]

  cidr        = "10.201.0.0/16"
  region      = "us-east-2"
  zones       = ["use2-az1", "use2-az2", "use2-az3"]
  zones_names = ["us-east-2a", "us-east-2b", "us-east-2c"]
  
  # cidr        = "10.222.0.0/16"
  # region      = "eu-west-2"
  # zones       = ["euw2-az1", "euw2-az2", "euw2-az3"]
  # zones_names = ["eu-west-2c", "eu-west-2a", "eu-west-2b"]

}

components_both_regions = {

    jumpbox = {
      instance_count = 1
      instance_type  = "t3.medium"
      subnet_type_public = true
    }
}


cp_components = {
    jumpbox = {
      instance_count = 1
      instance_type  = "t3.medium"
      subnet_type_public = true
    }
    # zookeeper = {
    #   instance_count = 5
    #   #instance_type  = "t3.medium"
    #   instance_type  = "t3.large"
    #   subnet_type_public = true
    #   #subnet_type_public = false
    # }
    # kafka = {
    #   instance_count = 8
    #   #instance_type  = "t3.2xlarge"
    #   instance_type  = "m5.4xlarge"
    #   #instance_type  = "m5.2xlarge"
    #   subnet_type_public = true
    # }
    # controlcenter = {
    #   instance_count = 2
    #   #instance_type  = "t3.2xlarge"
    #   instance_type  = "m5.2xlarge"
    #   subnet_type_public = true
    # }
    # schemaregistry = {
    #   instance_count = 4
    #   instance_type  = "t3.medium"
    #   subnet_type_public = true
    # }
    # connect = {
    #   instance_count = 4
    #   #instance_type  = "t3.medium"
    #   instance_type  = "t3.xlarge"
    #   subnet_type_public = true
    # }
    # restproxy = {
    #  instance_count = 3
    #  instance_type = "t3.2xlarge"
    #  subnet_type_public = true
    # }
    # ksql = {
    #   instance_count = 4
    #   #instance_type = "t3.large"
    #   instance_type  = "t3.xlarge"
    #   subnet_type_public = true
    # }
    # replicator = {
    #   instance_count = 1
    #   instance_type  = "t3.medium"
    # }
 
}



