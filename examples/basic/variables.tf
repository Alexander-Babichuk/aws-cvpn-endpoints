# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------
variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

variable "aws_vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_vpn_pool_cidr" {
  description = "The IPv4 address range, in CIDR notation, from which to assign client IP addresses."
  type        = string
  default     = "172.31.0.0/22"
}

variable "ssh_port" {
  description = "By default, SSH runs on port 22."
  type        = number
  default     = 22
}