# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------

output "arn" {
  description = "The ID of the Client VPN endpoint."
  value = aws_ec2_client_vpn_endpoint.this.arn
}

output "dns_name" {
  description = "The ARN of the Client VPN endpoint."
  value = aws_ec2_client_vpn_endpoint.this.dns_name
}

output "id" {
  description = "The DNS name to be used by clients when establishing their VPN session."
  value = aws_ec2_client_vpn_endpoint.this.id
}

output "status" {
  description = "The current state of the Client VPN endpoint."
  value = aws_ec2_client_vpn_endpoint.this.status
}
