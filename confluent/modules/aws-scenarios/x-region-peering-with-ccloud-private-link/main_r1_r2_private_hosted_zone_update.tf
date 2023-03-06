resource "aws_route53_zone_association" "r1_update" {
  zone_id  = module.aws_dedicated_ccloud_clstr_privatelink_r1.created_aws_route53_zone_id
  vpc_id   = module.aws_network_vpc_r2.created_aws_vpc_id
  provider = aws.r2
}

resource "aws_route53_zone_association" "r2_update" {
  zone_id  = module.aws_dedicated_ccloud_clstr_privatelink_r2.created_aws_route53_zone_id
  vpc_id   = module.aws_network_vpc_r1.created_aws_vpc_id
  provider = aws.r1
}
