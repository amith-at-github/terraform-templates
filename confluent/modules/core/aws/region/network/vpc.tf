
# Initialize availability zone data from AWS
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "zone-id"
    values = var.selected_azs
  }
}

# Vpc resource
resource "aws_vpc" "myVpc" {
  #  cidr_block           = "10.0.0.0/16"
  cidr_block           = var.aws_ipv4_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Amith-vpc"
  }
}

# Internet gateway for the public subnets
resource "aws_internet_gateway" "myInternetGateway" {
  vpc_id = aws_vpc.myVpc.id

  tags = {
    Name = "Amith-InternetGateway"
  }
}


# Routing table for public subnets
resource "aws_route_table" "rtblPublic" {
  vpc_id = aws_vpc.myVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myInternetGateway.id
  }

  tags = {
    Name = "Amith-rtbl-Public"
  }
}

resource "aws_route_table_association" "route" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.rtblPublic.id
}

# Elastic IP for NAT gateway
# EIP has error revisit later
resource "aws_eip" "nat" {
  vpc        = true
  depends_on = [aws_internet_gateway.myInternetGateway]
  tags = {
    Name = "Amith-eip-nat"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 1)
  depends_on    = [aws_internet_gateway.myInternetGateway]
  tags = {
    Name = "Amith-nat-gw"
  }
}

# Routing table for private subnets
resource "aws_route_table" "rtblPrivate" {
  vpc_id = aws_vpc.myVpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "Amith-rtbl-Private"
  }
}

//resource "aws_route_table_association" "private_route" {
resource "aws_route_table_association" "private_route" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.rtblPrivate.id
}

resource "aws_main_route_table_association" "private_main_route_table" {
  vpc_id         = aws_vpc.myVpc.id
  route_table_id = aws_route_table.rtblPrivate.id
}

# Subnet (public)
resource "aws_subnet" "public_subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.myVpc.id
  cidr_block              = cidrsubnet(var.aws_ipv4_cidr, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Amith-PublicSubnet"
  }
}

# Subnet (private)
resource "aws_subnet" "private_subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.myVpc.id
  cidr_block              = cidrsubnet(var.aws_ipv4_cidr, 8, (count.index + length(data.aws_availability_zones.available.names)))
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "Amith-PrivateSubnet"
  }
}

locals {
  subnet_instances = flatten([
    for s in setunion(aws_subnet.public_subnet, aws_subnet.private_subnet) : {
      subnet_id          = s.id
      subnet_type        = (s.map_public_ip_on_launch == true ? "public" : "private")
      subnect_cidr_block = s.cidr_block
      subnet_az_id       = s.availability_zone_id
      subnet_az          = s.availability_zone
    }

  ])

  subnet_instances_map = {
    for inst in local.subnet_instances : inst.subnet_az_id => inst...
  }
}
