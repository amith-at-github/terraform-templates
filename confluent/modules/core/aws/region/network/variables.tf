# Variables

# variable "aws_region" {
#   description = "The AWS region to use (e.g. eu-west-2)"
#   type        = string
#   #default     = "eu-west-2"
#   # default = "ca-central-1"
# }

# variable "aws_availability_zone" {
#   description = "The AWS availbility zone to use (e.g. eu-west-2c)"
#   type        = string
#   default     = "eu-west-2c"
# }

variable "aws_ipv4_cidr" {
  type = string
  #   default = "10.9.0.0/16"
  default = "10.9.0.0/16"
}

variable "selected_azs" {
  type = list(any)

}
