# ------------------------------------------------------------------------------
# EC2 VPCs section
# ------------------------------------------------------------------------------

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name        = format("%s-vpc", local.prefix)
  cidr        = var.aws_vpc_cidr
  enable_ipv6 = false
  azs         = data.aws_availability_zones.available_az.names

  private_subnets = [
    for num in range(0, 2) : cidrsubnet(local.private_cidr, 1, num)
  ]

  public_subnets = [
    for num in range(0, 2) : cidrsubnet(local.public_cidr, 1, num)
  ]

  private_subnet_tags = {
    Tier = "private"
  }

  public_subnet_tags = {
    Tier = "public"
  }

  private_route_table_tags = {
    Tier = "private"
  }

  public_route_table_tags = {
    Tier = "public"
  }

  enable_dns_support   = true
  enable_dns_hostnames = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  reuse_nat_ips          = false
  one_nat_gateway_per_az = false

  enable_vpn_gateway = false

  tags = {
    Environment = local.environment
    Name        = format("%s-vpc", local.prefix)
    Terraform   = "true"

  }
}
