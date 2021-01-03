# ------------------------------------------------------------------------------
# Outputs for main module
# ------------------------------------------------------------------------------
output "ec2_private_ip" {
  description = "A private IP of EC2 instance in the private subnet."
  value       = aws_instance.this.private_ip
}

output "ssh_private_key_file" {
  description = "A private SSH key of EC2 instance in private subnet."
  value       = local_file.ssh_private_key.filename
}

output "ssh_connection" {
  description = "ssh connection to the EC2 instance in the private subnet."
  value       = format(
          "ssh ec2-user@%s -i %s" ,
          aws_instance.this.private_ip,
          local_file.ssh_private_key.filename
  )
}
# ------------------------------------------------------------------------------
# Outputs for client VPN endpoint module
# ------------------------------------------------------------------------------
output "arn" {
  description = "The ID of the Client VPN endpoint."
  value       = module.dev-cvpn-endpoints.arn
}

output "dns_name" {
  description = "The ARN of the Client VPN endpoint."
  value       = module.dev-cvpn-endpoints.dns_name
}

output "id" {
  description = "The DNS name to be used by clients when establishing their VPN session."
  value       = module.dev-cvpn-endpoints.id
}

output "status" {
  description = "The current state of the Client VPN endpoint."
  value       = module.dev-cvpn-endpoints.status
}
