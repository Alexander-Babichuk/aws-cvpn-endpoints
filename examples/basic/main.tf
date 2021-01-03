terraform {
  required_version = ">= 0.12"
}

locals {
  project     = "vpn-hub"
  environment = "dev"
  prefix      = format("%s-%s", local.project, local.environment)

  # CIDR of public subnets
  private_cidr = cidrsubnet(var.aws_vpc_cidr, 1, 0)
  # CIDR of private subnets
  public_cidr = cidrsubnet(var.aws_vpc_cidr, 1, 1)

}

# Providers
provider "aws" {
  region = var.aws_region
}

module "dev-cvpn-endpoints" {
  source = "../../"

  client_cidr_block     = var.aws_vpn_pool_cidr
  associate_subnet_ids  = module.vpc.private_subnets
  organization          = "Acme Corporation"
  common_name           = "dev.acme.com"
  validity_period_hours = "8784" # 366 days
  cloudwatch_logging    = true

  tags = {
    Environment = local.environment
  }
}

resource "aws_ec2_client_vpn_authorization_rule" "client-vpn-endpoints" {
  client_vpn_endpoint_id = module.dev-cvpn-endpoints.id
  target_network_cidr    = var.aws_vpc_cidr
  authorize_all_groups   = true
}
