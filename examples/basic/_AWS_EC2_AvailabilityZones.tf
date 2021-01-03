# ------------------------------------------------------------------------------
# EC2 Availability Zones section
# ------------------------------------------------------------------------------

# Declare AWS availability zones in region
data "aws_availability_zones" "available_az" {
  state = "available"
}
