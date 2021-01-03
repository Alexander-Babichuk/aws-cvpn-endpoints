# ------------------------------------------------------------------------------
# AWS EC2 Instances section.
# ------------------------------------------------------------------------------

# "Amazon Linux 2 AMI (HVM), SSD Volume Type"
# aws ec2 describe-images --image-ids ami-XXXX | grep "OwnerId"
data "aws_ami" "amzn2" {
  most_recent = true
  owners      = ["137112412989"] # amazon

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.amzn2.id
  instance_type = "t2.small"
  subnet_id     = element(module.vpc.private_subnets, 0)
  key_name      = aws_key_pair.public_key.key_name

  disable_api_termination     = false
  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.ingress_sg.id,
    aws_security_group.egress_sg.id,
  ]

  tags = {
    Environment = local.environment
    Name        = format("%s-test-instance", local.prefix)
    Terraform   = "true"
  }
}
