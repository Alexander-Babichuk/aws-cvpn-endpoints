# AWS Client VPN Endpoint Terraform module
This module implements mutual authentication only. For more information on usage, please see the [AWS Client VPN Administrator's Guide](https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/cvpn-getting-started.html).

## Terraform versions

Terraform 0.14 and newer.Submit pull-requests to `master` branch.

## Usage

```hcl
module "dev-cvpn-endpoint" {
  source = "github.com/Alexander-Babichuk/aws-cvpn-endpoints.git"

  client_cidr_block     = "172.31.0.0/22"
  associate_subnet_ids  = ["subnet-0123456789abcdf", "subnet-fdcba9876543210"]
  organization          = "Acme Corporation"
  common_name           = "dev.acme.com"
  validity_period_hours = "8784" # 366 days
  cloudwatch_logging    = true

  tags = {
    Environment = "dev"
  }
}

resource "aws_ec2_client_vpn_authorization_rule" "dev-cvpn-endpoint" {
  client_vpn_endpoint_id = module.dev-cvpn-endpoint.id
  target_network_cidr    = "10.0.0.0/16"
  authorize_all_groups   = true
}

```

```shell
terraform init
terraform plan
terraform apply -auto-approve
sudo openvpn --config dev_acme_com_cvpn_endpoint.conf
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0.0 |

## Inputs

* ```client_cidr_block``` - (Required) The IPv4 address range, in CIDR notation, from which to assign client IP addresses. The address range cannot overlap with the local CIDR of the VPC in which the associated subnet is located, or the routes that you add manually. The address range cannot be changed after the Client VPN endpoint has been created. The CIDR block must be /22 or greater.
* ```common_name``` - (Required) The Common Name (CN), also known as the Fully Qualified Domain Name (FQDN), is the characteristic value within a Distinguished Name. Typically, it is composed of Host Domain Name and looks like, "example.com"
* ```organization``` - (Required) The name of the department or organization unit making the request.
* ```validity_period_hours``` - (Required) The number of hours after initial issuing that the cert will become invalid.
* ```associate_subnet_ids``` - (Optional) The list of subnet-ids that will be associate with AWS Client VPN endpoint. Default value is ```[]```.
* ```cloudwatch_logging ```- (Optional) Indicates whether connection logging is enabled. Default value is ```false```.
* ```cloudwatch_retention_period``` - (Optional) Specifies the number of days you want to retain log events. Default value is ```30```.
* ```private_key_rsa_bits``` - (Optional)  The size of the generated RSA key in bits. Defaults to ```2048```.
* ```tags``` - (Optional) A map of tags to add to all resources. Default value is ```{}```.
* ```transport_protocol``` - (Optional) The transport layer protocol to be used by the VPN session. Default value is ```tcp```.


## Outputs

* ```id``` - The ID of the Client VPN endpoint.
* ```arn``` - The ARN of the Client VPN endpoint.
* ```dns_name``` - The DNS name to be used by clients when establishing their VPN session.
* ```status``` - The current state of the Client VPN endpoint.

## License

Apache 2 Licensed. See LICENSE for full details.