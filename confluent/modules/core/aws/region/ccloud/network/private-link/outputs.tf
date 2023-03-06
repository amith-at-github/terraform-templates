output "created_aws_route53_zone_id" {
  value       = aws_route53_zone.privatelink.zone_id
  description = "AWS created private hosted zone id"
}

output "created_aws_route53_zone_name" {
  value       = aws_route53_zone.privatelink.name
  description = "AWS created private hosted zone name."
}
