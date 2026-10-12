############################################
# Outputs - Transit Gateway Peering
############################################

output "tgw_r1_id" {
  value       = aws_ec2_transit_gateway.tgw_r1.id
  description = "Transit Gateway ID in region r1."
}

output "tgw_r2_id" {
  value       = aws_ec2_transit_gateway.tgw_r2.id
  description = "Transit Gateway ID in region r2."
}

output "tgw_peering_attachment_id" {
  value       = aws_ec2_transit_gateway_peering_attachment.r1_to_r2.id
  description = "Transit Gateway peering attachment ID (r1 -> r2)."
}

output "tgw_peering_attachment_state" {
  value       = aws_ec2_transit_gateway_peering_attachment_accepter.r2_accept_r1
  # value       = aws_ec2_transit_gateway_peering_attachment_accepter.r2_accept_r1.state
  description = "State of the accepted peering attachment on the r2 side."
}

output "tgw_attachment_r1_id" {
  value       = aws_ec2_transit_gateway_vpc_attachment.attach_r1.id
  description = "Transit Gateway VPC attachment ID for r1 private subnets."
}

output "tgw_attachment_r2_id" {
  value       = aws_ec2_transit_gateway_vpc_attachment.attach_r2.id
  description = "Transit Gateway VPC attachment ID for r2 private subnets."
}
