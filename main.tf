# Local vars
locals {
  bundle = replace(trim(var.common_name, "."), ".", "_")

  cloudwatch_log_group  = format("%s_log_group", local.bundle)
  cloudwatch_log_stream = format("%s_log_stream", local.bundle)

  cvpn_config_template = format("%s/files/cvpn-endpoint.conf.tpl", path.module)
}

resource "aws_cloudwatch_log_group" "this" {
  count             = var.cloudwatch_logging ? 1 : 0
  name              = local.cloudwatch_log_group
  retention_in_days = var.cloudwatch_retention_period

  tags = merge(
    var.tags,
    {
      Bundle    = local.bundle
      Terraform = "true"
    }
  )
}

resource "aws_cloudwatch_log_stream" "this" {
  count          = var.cloudwatch_logging ? 1 : 0
  name           = local.cloudwatch_log_stream
  log_group_name = local.cloudwatch_log_group
  depends_on     = [aws_cloudwatch_log_group.this]
}

resource "aws_ec2_client_vpn_endpoint" "this" {
  description            = format("%s cvpn endpoint.", local.bundle)
  server_certificate_arn = aws_acm_certificate.server_side.arn
  client_cidr_block      = var.client_cidr_block
  transport_protocol     = var.transport_protocol

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.client_side.arn
  }

  split_tunnel = true

  connection_log_options {
    enabled               = false
    cloudwatch_log_group  = local.cloudwatch_log_group
    cloudwatch_log_stream = local.cloudwatch_log_stream
  }

  tags = merge(
    var.tags,
    {
      Bundle    = local.bundle
      Terraform = "true"
    }
  )
}

resource "aws_ec2_client_vpn_network_association" "vpn_endpoint" {
  count                  = length(var.associate_subnet_ids)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  subnet_id              = var.associate_subnet_ids[count.index]

  lifecycle {
    ignore_changes = [subnet_id]
  }
}

data "template_file" "cvpn_conf" {
  template = file(local.cvpn_config_template)

  vars = {
    endpoint_dns_name  = trim(aws_ec2_client_vpn_endpoint.this.dns_name, "*-.")
    transport_protocol = var.transport_protocol
    certificate_chain  = tls_self_signed_cert.ca.cert_pem
    certificate_body   = tls_locally_signed_cert.client_side.cert_pem
    private_key_body   = tls_private_key.client_side.private_key_pem
  }
}

# Export rendered vpn config to file.
resource "local_file" "cvpn_endpoint_conf" {
  content         = data.template_file.cvpn_conf.rendered
  filename        = format("%s_cvpn_endpoint.conf", local.bundle)
  file_permission = "0600"
}
