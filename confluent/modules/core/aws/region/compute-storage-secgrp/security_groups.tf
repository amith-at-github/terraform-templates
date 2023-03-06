

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}


resource "aws_security_group" "public_bastion_sgs" {
  name        = "confluent-platform-bastion-sg"
  description = "Allow public inbound traffic"
  #vpc_id      = "${aws_vpc.myVpc.id}"
  vpc_id = var.created_aws_vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    description = "SSH"
  }


  # ICMP (any)
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "icmp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    # cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = ["${var.aws_ipv4_cidr}"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    description = "Control Center"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    description = "Control Center"
  }
  ingress {
    from_port   = 9021
    to_port     = 9021
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    description = "Control Center"
  }
  ingress {
    from_port   = 9091
    to_port     = 9099
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    description = "Kafka Primary"
  }
  ingress {
    from_port   = 9191
    to_port     = 9199
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    description = "Kafka Extra"
  }
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    description = "Schema Registry"
  }
  ingress {
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    description = "Kafka Connect"
  }
  ingress {
    from_port   = 8090
    to_port     = 8090
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    description = "Metadata Service"
  }
  ingress {
    from_port   = 8075
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    description = "Reserving for JMX ports-choose per config"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.resource_name}"
    Owner       = "${var.resource_owner}"
    Email       = "${var.resource_email}"
    Purpose     = "${var.resource_purpose}"
    owner_email = "${var.resource_email}"
  }

}

resource "aws_security_group" "priv_subnet_sgs" {
  name        = "Private-Subnets-security-group"
  description = "Used only for private subnet and also by cross region peering & other ccloud lnks"
  #vpc_id      = "${aws_vpc.myVpc.id}"
  vpc_id = var.created_aws_vpc_id


  #Needed for bastion public host to connect to the private subnet ssh
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }
  # ICMP (any)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # only necessary if redirect support from http/https is desired
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    # cidr_blocks = [data.aws_vpc.privatelink.cidr_block]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    # cidr_blocks = [data.aws_vpc.privatelink.cidr_block]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 9092
    to_port   = 9092
    protocol  = "tcp"
    # cidr_blocks = [data.aws_vpc.privatelink.cidr_block]
    cidr_blocks = ["0.0.0.0/0"]
  }


  # THis was added later 
  ingress {
    description = "Allow all access inside the subnets"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.resource_name}"
    Owner       = "${var.resource_owner}"
    Email       = "${var.resource_email}"
    Purpose     = "${var.resource_purpose}"
    owner_email = "${var.resource_email}"
  }
}