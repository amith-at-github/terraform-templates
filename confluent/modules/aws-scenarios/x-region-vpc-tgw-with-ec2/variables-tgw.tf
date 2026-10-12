############################################
# Variables - Transit Gateway Peering
############################################

# variable "region_r1" {
#   description = "AWS region for VPC r1 (must match the provider used by module.aws_network_vpc_r1)."
#   type        = string
# }

# variable "region_r2" {
#   description = "AWS region for VPC r2 (must match the provider used by module.aws_network_vpc_r2)."
#   type        = string
# }

variable "tgw_r1_asn" {
  description = "Amazon side ASN for the r1 Transit Gateway. Must differ from tgw_r2_asn and not overlap with any BGP ASN already in use."
  type        = number
  default     = 64512
}

variable "tgw_r2_asn" {
  description = "Amazon side ASN for the r2 Transit Gateway. Must differ from tgw_r1_asn and not overlap with any BGP ASN already in use."
  type        = number
  default     = 64513
}
