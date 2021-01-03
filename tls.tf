# ------------------------------------------------------------------------------
#  Generate the root CA
# ------------------------------------------------------------------------------

# Create CA private key
resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = var.rsa_bits
}

# Export the CA private key in a file.
resource "local_file" "ca_key" {
  content         = tls_private_key.ca.private_key_pem
  filename        = format("%s_ca.key", local.bundle)
  file_permission = "0600"
}

# Create CA public cert
resource "tls_self_signed_cert" "ca" {
  key_algorithm     = tls_private_key.ca.algorithm
  private_key_pem   = tls_private_key.ca.private_key_pem
  is_ca_certificate = true

  validity_period_hours = var.validity_period_hours

  # RFC5280 https://www.terraform.io/docs/providers/tls/r/self_signed_cert.html#allowed_uses."
  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]

  subject {
    common_name  = var.common_name
    organization = var.organization
  }
}

# Export the CA public cert in a file.
resource "local_file" "ca_cert" {
  content         = tls_self_signed_cert.ca.cert_pem
  filename        = format("%s_ca.crt", local.bundle)
  file_permission = "0600"
}

# ------------------------------------------------------------------------------
# Generate server side side tls bundle
# ------------------------------------------------------------------------------

# Create server side private key
resource "tls_private_key" "server_side" {
  algorithm = "RSA"
  rsa_bits  = var.rsa_bits
}

# Export the cert`s private key to a file.
resource "local_file" "server_key" {
  content         = tls_private_key.server_side.private_key_pem
  filename        = format("%s_server.key", local.bundle)
  file_permission = "0600"
}

# Create server side public cert signing request(CSR)
resource "tls_cert_request" "server_side" {
  key_algorithm   = tls_private_key.server_side.algorithm
  private_key_pem = tls_private_key.server_side.private_key_pem

  subject {
    common_name  = format("server.%s", var.common_name)
    organization = var.organization
  }
}

# Create server side signed public cert
resource "tls_locally_signed_cert" "server_side" {
  cert_request_pem = tls_cert_request.server_side.cert_request_pem

  ca_key_algorithm   = tls_private_key.ca.algorithm
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = var.validity_period_hours

  # RFC5280 https://www.terraform.io/docs/providers/tls/r/self_signed_cert.html#allowed_uses."
  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
  ]
}

# Export the cert`s public key to a file.
resource "local_file" "server_cert" {
  content         = tls_locally_signed_cert.server_side.cert_pem
  filename        = format("%s_server.crt", local.bundle)
  file_permission = "0600"
}

# Import server side certificates to ACM
resource "aws_acm_certificate" "server_side" {
  private_key       = tls_private_key.server_side.private_key_pem
  certificate_body  = tls_locally_signed_cert.server_side.cert_pem
  certificate_chain = tls_self_signed_cert.ca.cert_pem
  tags = merge(
    var.tags,
    {
      Bundle    = local.bundle
      Terraform = "true"
      Tier      = "server-side"
    }
  )
}

# ------------------------------------------------------------------------------
# Generate client side tls bundle
# ------------------------------------------------------------------------------

# Create client side private key
resource "tls_private_key" "client_side" {
  algorithm = "RSA"
  rsa_bits  = var.rsa_bits
}

# Export the cert`s private key to a file.
resource "local_file" "client_key" {
  content         = tls_private_key.client_side.private_key_pem
  filename        = format("%s_client.key", local.bundle)
  file_permission = "0600"
}

# Create client side public cert signing request(CSR)
resource "tls_cert_request" "client_side" {
  key_algorithm   = tls_private_key.client_side.algorithm
  private_key_pem = tls_private_key.client_side.private_key_pem

  subject {
    common_name  = format("client.%s", var.common_name)
    organization = var.organization
  }
}

# Create client side signed public cert
resource "tls_locally_signed_cert" "client_side" {
  cert_request_pem = tls_cert_request.client_side.cert_request_pem

  ca_key_algorithm   = tls_private_key.ca.algorithm
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = var.validity_period_hours

  # RFC5280 https://www.terraform.io/docs/providers/tls/r/self_signed_cert.html#allowed_uses."
  allowed_uses = [
    "digital_signature",
    "key_agreement",
    "client_auth",
  ]
}

# Export the cert`s public key to a file.
resource "local_file" "client_cert" {
  content         = tls_locally_signed_cert.client_side.cert_pem
  filename        = format("%s_client.crt", local.bundle)
  file_permission = "0600"
}

# Import client side certificates to ACM
resource "aws_acm_certificate" "client_side" {
  private_key       = tls_private_key.client_side.private_key_pem
  certificate_body  = tls_locally_signed_cert.client_side.cert_pem
  certificate_chain = tls_self_signed_cert.ca.cert_pem

  tags = merge(
    var.tags,
    {
      Bundle    = local.bundle
      Terraform = "true"
      Tier      = "client-side"
    }
  )
}
