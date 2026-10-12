############################################
# Data sources - fetch each VPC's CIDR block
# so we can scope routes to the *whole* private
# network of the peer VPC without hardcoding CIDRs.
############################################

data "aws_vpc" "vpc_r1" {
  provider = aws.r1
  id       = module.aws_network_vpc_r1.created_aws_vpc_id
}

data "aws_vpc" "vpc_r2" {
  provider = aws.r2
  id       = module.aws_network_vpc_r2.created_aws_vpc_id
}

############################################
# Transit Gateways (one per region)
############################################

resource "aws_ec2_transit_gateway" "tgw_r1" {
  provider                        = aws.r1
  description                     = "Transit Gateway - Region r1"
  amazon_side_asn                 = var.tgw_r1_asn
  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name = "tgw-r1"
  }
}

resource "aws_ec2_transit_gateway" "tgw_r2" {
  provider                        = aws.r2
  description                     = "Transit Gateway - Region r2"
  amazon_side_asn                 = var.tgw_r2_asn
  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name = "tgw-r2"
  }
}

############################################
# TGW VPC Attachments - PRIVATE SUBNETS ONLY
############################################

resource "aws_ec2_transit_gateway_vpc_attachment" "attach_r1" {
  provider                                        = aws.r1
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw_r1.id
  vpc_id                                           = module.aws_network_vpc_r1.created_aws_vpc_id
  subnet_ids                                       = module.aws_network_vpc_r1.created_aws_private_subnets
  transit_gateway_default_route_table_association  = false
  transit_gateway_default_route_table_propagation  = false

  tags = {
    Name = "tgw-attach-r1-private"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "attach_r2" {
  provider                                        = aws.r2
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw_r2.id
  vpc_id                                           = module.aws_network_vpc_r2.created_aws_vpc_id
  subnet_ids                                       = module.aws_network_vpc_r2.created_aws_private_subnets
  transit_gateway_default_route_table_association  = false
  transit_gateway_default_route_table_propagation  = false

  tags = {
    Name = "tgw-attach-r2-private"
  }
}

############################################
# Cross-region TGW Peering
############################################

resource "aws_ec2_transit_gateway_peering_attachment" "r1_to_r2" {
  provider                = aws.r1
  transit_gateway_id      = aws_ec2_transit_gateway.tgw_r1.id
  peer_transit_gateway_id = aws_ec2_transit_gateway.tgw_r2.id
  peer_region             = var.aws_region_details_r2.region
  tags = {
    Name = "tgw-peer-r1-to-r2"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "r2_accept_r1" {
  provider                       = aws.r2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.r1_to_r2.id

  tags = {
    Name = "tgw-peer-r2-accepted-from-r1"
  }
}

############################################
# TGW Route Tables (custom, not default)
############################################

resource "aws_ec2_transit_gateway_route_table" "rt_r1" {
  provider           = aws.r1
  transit_gateway_id = aws_ec2_transit_gateway.tgw_r1.id

  tags = {
    Name = "tgw-rt-r1"
  }
}

resource "aws_ec2_transit_gateway_route_table" "rt_r2" {
  provider           = aws.r2
  transit_gateway_id = aws_ec2_transit_gateway.tgw_r2.id

  tags = {
    Name = "tgw-rt-r2"
  }
}

# Associate the VPC attachments with their local route table
resource "aws_ec2_transit_gateway_route_table_association" "assoc_r1_vpc" {
  provider                       = aws.r1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attach_r1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_r1.id
}

resource "aws_ec2_transit_gateway_route_table_association" "assoc_r2_vpc" {
  provider                       = aws.r2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.attach_r2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_r2.id
}

# Associate the peering attachments with their local route table
resource "aws_ec2_transit_gateway_route_table_association" "assoc_r1_peer" {
  provider                       = aws.r1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.r1_to_r2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_r1.id

  depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.r2_accept_r1]
}


resource "aws_ec2_transit_gateway_route_table_association" "assoc_r2_peer" {
  provider                       = aws.r2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.r2_accept_r1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_r2.id
}

############################################
# TGW Routes - point each side's TGW route table
# at the peering attachment for the *other* VPC's CIDR
############################################

resource "aws_ec2_transit_gateway_route" "route_r1_to_r2" {
  provider                       = aws.r1
  destination_cidr_block         = data.aws_vpc.vpc_r2.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.r1_to_r2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_r1.id

  # Same reasoning as assoc_r1_peer above - must wait for acceptance.
  depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.r2_accept_r1]
}

resource "aws_ec2_transit_gateway_route" "route_r2_to_r1" {
  provider                       = aws.r2
  destination_cidr_block         = data.aws_vpc.vpc_r1.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.r2_accept_r1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_r2.id
}

############################################
# VPC private route table updates
#
# Sends traffic destined for the *peer* VPC's CIDR
# out through the local Transit Gateway attachment.
#
# ASSUMPTION: created_aws_private_route_table_r1/r2 are single
# route table IDs (one shared private route table per VPC).
############################################

resource "aws_route" "r1_private_to_r2" {
  provider                = aws.r1
  route_table_id          = module.aws_network_vpc_r1.created_aws_private_route_table
  destination_cidr_block  = data.aws_vpc.vpc_r2.cidr_block
  transit_gateway_id      = aws_ec2_transit_gateway.tgw_r1.id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.attach_r1]
}

resource "aws_route" "r2_private_to_r1" {
  provider                = aws.r2
  route_table_id          = module.aws_network_vpc_r2.created_aws_private_route_table
  destination_cidr_block  = data.aws_vpc.vpc_r1.cidr_block
  transit_gateway_id      = aws_ec2_transit_gateway.tgw_r2.id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.attach_r2]
}

############################################
# ALTERNATE VERSION - if created_aws_private_route_table_r1/r2
# actually return a LIST of route table IDs (e.g. one per AZ),
# comment out the two aws_route resources above and use this
# for_each version instead:
############################################

# resource "aws_route" "r1_private_to_r2" {
#   provider                = aws
#   for_each                = toset(module.aws_network_vpc_r1.created_aws_private_route_table)
#   route_table_id          = each.value
#   destination_cidr_block  = data.aws_vpc.vpc_r2.cidr_block
#   transit_gateway_id      = aws_ec2_transit_gateway.tgw_r1.id
#   depends_on              = [aws_ec2_transit_gateway_vpc_attachment.attach_r1]
# }
#
# resource "aws_route" "r2_private_to_r1" {
#   provider                = aws.r2
#   for_each                = toset(module.aws_network_vpc_r2.created_aws_private_route_table)
#   route_table_id          = each.value
#   destination_cidr_block  = data.aws_vpc.vpc_r1.cidr_block
#   transit_gateway_id      = aws_ec2_transit_gateway.tgw_r2.id
#   depends_on              = [aws_ec2_transit_gateway_vpc_attachment.attach_r2]
# }
