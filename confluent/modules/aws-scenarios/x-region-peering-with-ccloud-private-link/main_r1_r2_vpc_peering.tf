# Initiated from region 1
resource "aws_vpc_peering_connection" "peering" {
  vpc_id      = module.aws_network_vpc_r1.created_aws_vpc_id
  peer_vpc_id = module.aws_network_vpc_r2.created_aws_vpc_id
  peer_region = var.aws_region_details_r2.region

  provider = aws.r1
}

# Accepted in region 2
resource "aws_vpc_peering_connection_accepter" "peering" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  auto_accept               = true

  provider = aws.r2
}

resource "aws_vpc_peering_connection_options" "r1" {
  # Options can't be set until the connection has been accepted
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peering.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  provider = aws.r1
}

resource "aws_vpc_peering_connection_options" "r2" {
  # Options can't be set until the connection has been accepted
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peering.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  provider = aws.r2
}


# Find the routing table
data "aws_route_table" "rts_r1" {
  vpc_id         = module.aws_network_vpc_r1.created_aws_vpc_id
  route_table_id = module.aws_network_vpc_r1.created_aws_private_route_table
  provider       = aws.r1
  depends_on = [
    module.aws_network_vpc_r1
  ]
}

# Find the routing table
data "aws_route_table" "rts_r2" {

  vpc_id         = module.aws_network_vpc_r2.created_aws_vpc_id
  route_table_id = module.aws_network_vpc_r2.created_aws_private_route_table
  provider       = aws.r2
  depends_on = [
    module.aws_network_vpc_r2
  ]
}

resource "aws_route" "r1_peering" {
  route_table_id            = data.aws_route_table.rts_r1.id
  destination_cidr_block    = var.aws_region_details_r2.cidr
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peering.id

  provider = aws.r1
  depends_on = [
    module.aws_network_vpc_r1
  ]
}

resource "aws_route" "r2_peering" {
  route_table_id            = data.aws_route_table.rts_r2.id
  destination_cidr_block    = var.aws_region_details_r1.cidr
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peering.id

  provider = aws.r2
  depends_on = [
    module.aws_network_vpc_r2
  ]
}