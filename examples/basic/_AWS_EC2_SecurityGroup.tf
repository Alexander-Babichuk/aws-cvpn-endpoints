# ------------------------------------------------------------------------------
# EC2 Security Groups section
# ------------------------------------------------------------------------------

# Default Security Group
resource "aws_default_security_group" "default_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    # Allow all outbound connections
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "egress_sg" {
  name   = format("%s-egress-sg", local.project)
  vpc_id = module.vpc.vpc_id

  # Allow all outbound connections
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "ingress_sg" {
  name   = format("%s-ingress-sg", local.project)
  vpc_id = module.vpc.vpc_id

  ingress {
    # Allow inbound SSH connections
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_ssh"
  }
}
