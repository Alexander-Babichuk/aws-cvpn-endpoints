# ------------------------------------------------------------------------------
# SSH keys section
# ------------------------------------------------------------------------------

# Generates SSH key pair
resource "tls_private_key" "ssh_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Imports public key to AWS region
resource "aws_key_pair" "public_key" {
  key_name   = format("%s-kp", local.project)
  public_key = tls_private_key.ssh_key_pair.public_key_openssh
}

resource "local_file" "ssh_private_key" {
  content         = tls_private_key.ssh_key_pair.private_key_pem
  filename        = format("./id_rsa")
  file_permission = "0600"
}
