
output "created_aws_security_group_public_bastion_sgs" {
  value       = aws_security_group.public_bastion_sgs.id
  description = "AWS created bastion hosts security groups"
}

output "created_aws_security_group_priv_subnet_sgs" {
  value       = aws_security_group.priv_subnet_sgs.id
  description = "AWS created private subnet security groups."
}

output "ec2_instance_details" {
  description = "EC2 Instance details"
  value = { for p in sort(keys(local.service_instances_map)) : p => ({
    "private_dns"   = aws_instance.component[p].private_dns,
    "public_dns"    = aws_instance.component[p].public_dns,
    "associated-az" = aws_instance.component[p].availability_zone
    }
    )
  }
}
