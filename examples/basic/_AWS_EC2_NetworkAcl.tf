# ------------------------------------------------------------------------------
# EC2 Network ACLs section
# ------------------------------------------------------------------------------

resource "aws_default_network_acl" "default_nacl" {
  default_network_acl_id = module.vpc.default_network_acl_id

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Environment = local.environment
    Name        = format("%s-nacl", local.prefix)
    Terraform   = "true"
  }
}
