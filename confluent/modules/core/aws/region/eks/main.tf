
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  cluster_name    = var.eks_cluster_name
  cluster_version = "1.22"

  #   vpc_id                         = module.vpc.vpc_id
  #   subnet_ids                     = module.vpc.private_subnets

  vpc_id     = var.created_aws_vpc_id
  subnet_ids = var.created_aws_private_subnets

  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true
  # write_kubeconfig=true
  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["m5.xlarge"]

      min_size     = 1
      max_size     = 4
      desired_size = 1
    }

    # two = {
    #   name = "node-group-2"

    #   instance_types = ["m5.xlarge"]

    #   min_size     = 1
    #   max_size     = 2
    #   desired_size = 1
    # }
  }

  # Necessary for AWS Load Balancer Controller to work properly
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    ingress_cluster_tcp = {
      description                   = "Cluster to node upper ports/protocols"
      protocol                      = "tcp"
      from_port                     = 1025
      to_port                       = 65535
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  tags = {
    # owner_email = var.owner
    Terraform = true
  }

  cluster_timeouts = {
    create = "60m",
    update = "60m",
    delete = "60m",
  }
}

# data "aws_region" "current" {}
