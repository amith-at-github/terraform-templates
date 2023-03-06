
# resource "confluent_environment" "staging" {
#   display_name = "Staging"
# }

# Stream Governance and Kafka clusters can be in different regions as well as different cloud providers,
# but you should to place both in the same cloud and region to restrict the fault isolation boundary.
# data "confluent_schema_registry_region" "essentials" {
#   cloud   = "AWS"
#   region  = "us-east-2"
#   package = "ESSENTIALS"
# }

# resource "confluent_schema_registry_cluster" "essentials" {
#   package = data.confluent_schema_registry_region.essentials.package

#   environment {
#     id = confluent_environment.staging.id
#   }

#   region {
#     # See https://docs.confluent.io/cloud/current/stream-governance/packages.html#stream-governance-regions
#     id = data.confluent_schema_registry_region.essentials.id
#   }
# }

resource "confluent_network" "private-link" {
  display_name     = "Private Link Network"
  cloud            = "AWS"
  region           = var.aws_region_details.region
  connection_types = ["PRIVATELINK"]
  zones            = var.aws_region_details.zones

  dns_config {
    resolution = "PRIVATE"
  }

  environment {
    id = var.ccloud_env_id
  }
}

resource "confluent_private_link_access" "aws" {
  display_name = "AWS Private Link Access"
  aws {
    account = var.aws_account_id
    # account = data.aws_caller_identity.caller_id.account_id
  }
  environment {
    id = var.ccloud_env_id
  }
  network {
    id = confluent_network.private-link.id
  }
}

# https://docs.confluent.io/cloud/current/networking/private-links/aws-privatelink.html
# Set up the VPC Endpoint for AWS PrivateLink in your AWS account
# Set up DNS records to use AWS VPC endpoints
locals {
  hosted_zone = length(regexall(".glb", confluent_kafka_cluster.dedicated.bootstrap_endpoint)) > 0 ? replace(regex("^[^.]+-([0-9a-zA-Z]+[.].*):[0-9]+$", confluent_kafka_cluster.dedicated.bootstrap_endpoint)[0], "glb.", "") : regex("[.]([0-9a-zA-Z]+[.].*):[0-9]+$", confluent_kafka_cluster.dedicated.bootstrap_endpoint)[0]
}

locals {
  bootstrap_prefix = split(".", confluent_kafka_cluster.dedicated.bootstrap_endpoint)[0]
}


resource "aws_vpc_endpoint" "privatelink" {
  vpc_id             = var.vpc_id
  service_name       = confluent_network.private-link.aws[0].private_link_endpoint_service
  vpc_endpoint_type  = "Interface"
  security_group_ids = [var.created_priv_subnet_sgs, ]

  # security_group_ids = [
  #   aws_security_group.privatelink.id,
  # ]



  subnet_ids          = var.created_aws_private_subnets
  private_dns_enabled = false

  depends_on = [
    confluent_private_link_access.aws,
  ]
}

resource "aws_route53_zone" "privatelink" {
  name = local.hosted_zone
  # comment = "${var.environment_name}-${var.r1.region}"

  vpc {
    vpc_id = var.vpc_id
  }
  lifecycle {
    ignore_changes = [vpc]
  }

}

resource "aws_route53_record" "privatelink" {
  count   = length(var.aws_region_details.zones) == 1 ? 0 : 1
  zone_id = aws_route53_zone.privatelink.zone_id
  name    = "*.${aws_route53_zone.privatelink.name}"
  type    = "CNAME"
  ttl     = "60"
  records = [
    aws_vpc_endpoint.privatelink.dns_entry[0]["dns_name"]
  ]
}

locals {
  endpoint_prefix = split(".", aws_vpc_endpoint.privatelink.dns_entry[0]["dns_name"])[0]
}

resource "aws_route53_record" "privatelink-zonal" {

  count   = length(var.aws_region_details.zones)
  zone_id = aws_route53_zone.privatelink.zone_id
  name    = length(var.aws_region_details.zones) == 1 ? "*" : "*.${var.aws_region_details.zones[count.index]}"
  type    = "CNAME"
  ttl     = "60"
  records = [
    format("%s-%s%s",
      local.endpoint_prefix,
      "${var.aws_region_details.zones_names[count.index]}",
      replace(aws_vpc_endpoint.privatelink.dns_entry[0]["dns_name"], local.endpoint_prefix, "")
    )
  ]
}
