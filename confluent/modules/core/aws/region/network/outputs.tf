# output "public_subnet" {
#  value       = aws_example_resource.example_device.random_string
#  description = "A random string from an example resource on AWS."
# }

output "created_aws_vpc_id" {
  value       = aws_vpc.myVpc.id
  description = "VPC id created in AWS."
}

output "created_aws_private_subnets" {
  value       = aws_subnet.private_subnet.*.id
  description = "AWS created private Subnets in VPC."
}

output "created_aws_public_route_table" {
  value       = aws_route_table.rtblPublic.id
  description = "AWS created public Subnets in VPC."
}

output "created_aws_private_route_table" {
  value       = aws_route_table.rtblPrivate.id
  description = "AWS created private Subnets in VPC."
}

output "created_aws_public_subnets" {
  value       = aws_subnet.public_subnet.*.id
  description = "AWS created public Subnets in VPC."
}


output "created_subnet_instance_details" {
  description = "subnet dteails details"
  value       = local.subnet_instances_map
}


