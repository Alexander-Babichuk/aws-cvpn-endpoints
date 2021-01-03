# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------
variable "client_cidr_block" {
  description = "The IPv4 address range, in CIDR notation, from which to assign client IP addresses."
  type        = string
}

variable "common_name" {
  description = "Common name(CN) to use in the subject of the cert (e.g., example.com)."
}

variable "organization" {
  description = "Organizational Unit(OU) to associate with the cert (e.g. Example LTD)."
}

variable "validity_period_hours" {
  description = "The number of hours after initial issuing that the cert will become invalid."
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------
variable "associate_subnet_ids" {
  description = "The list of the subnet ID to associate with the Client VPN endpoint."
  type        = list(string)
  default     = []
}

variable "transport_protocol" {
  description = "The transport layer protocol to be used by the VPN session."
  type        = string
  default     = "tcp"
}

variable "cloudwatch_logging" {
  description = "Indicates whether connection logging is enabled."
  type        = bool
  default     = false
}

variable "cloudwatch_retention_period" {
  description = "Specifies the number of days you want to retain log events."
  type        = string
  default     = "30"
}

variable "rsa_bits" {
  description = "The size of the generated RSA key in bits."
  default     = "2048"
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
