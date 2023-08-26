# owner                              = "<NAME>"
# owner_email                        = "<EMAIL>"
# environment_name                   = "<ENV_NAME>-<USED-BY-RESOURCES-AND-TAGS-FOR-DESCRIPTION""
# purpose                            = "<PURPOSE>"
# ssh_key_name                       = "<SOMETHING>-key-<JUST-A-NAME>"
# ssh_public_key_path                = "~/.ssh/<SOMETHING>.pub"

owner                              = "Amith"
owner_email                        = "ammanjunath@confleunt.io"
environment_name                   = "citi-demo-mrc"
purpose                            = "ps-enagement"
ssh_key_name                       = "amith-aws-demo-key-ssh"
ssh_public_key_path                = "~/.ssh/amith-aws-east1.pub"
aws_region_details_r1 = {
  region      = "us-east-1"
  cidr        = "10.19.0.0/16"
  # zones       = ["use1-az1", "use1-az2", "use1-az5"]
  # zones_names = ["us-east-1a", "us-east-1b", "us-east-1f"]
  zones       = ["use1-az1", "use1-az2"]
  zones_names = ["us-east-1a", "us-east-1b"]
}

cp_components = {
    jumpbox = {
      instance_count = 2
      # instance_type  = "t3.micro"
      instance_type  = "t3.medium"
      subnet_type_public = true
    }
    zookeeper = {
      instance_count = 5
      #instance_type  = "t3.medium"
      instance_type  = "t3.large"
      subnet_type_public = true
      #subnet_type_public = false
    }
    kafka = {
      instance_count = 8
      #instance_type  = "t3.2xlarge"
      instance_type  = "m5.4xlarge"
      #instance_type  = "m5.2xlarge"
      subnet_type_public = true
    }
    controlcenter = {
      instance_count = 2
      #instance_type  = "t3.2xlarge"
      instance_type  = "m5.2xlarge"
      subnet_type_public = true
    }
    schemaregistry = {
      instance_count = 4
      instance_type  = "t3.medium"
      subnet_type_public = true
    }
    connect = {
      instance_count = 4
      #instance_type  = "t3.medium"
      instance_type  = "t3.xlarge"
      subnet_type_public = true
    }
    # restproxy = {
    #   instance_count = 3
    #   instance_type = "t3.2xlarge"
    #   subnet_type_public = true
    # }
    ksql = {
      instance_count = 4
      #instance_type = "t3.large"
      instance_type  = "t3.xlarge"
      subnet_type_public = true
    }

    # #replicator = {
    # #  instance_count = 1
    # #  instance_type  = "t3.medium"
    # #}
 
}



