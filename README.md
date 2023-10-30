# quantspark
QuantSpark Tech Test

Static webpage deployed to an S3 origin and optimised with Cloudfront

[terraform]: https://www.terraform.io/downloads
[hashicorp/aws]: https://registry.terraform.io/providers/hashicorp/aws

## Requirements

| Name            | Version |
|-----------------|---------|
| [terraform]     | ~> 1.6  |
| [hashicorp/aws] | ~> 5.x  |

#### Note:

For this deployment, you'll need an exising route53 hosted zone that you can access and create records in

## Usage


__Plan__
`terraform plan -var zone_id=<ZONE ID>`

__Apply__
`terraform apply -var zone_id=<ZONE ID>`

__Destroy__
`terraform destroy -var zone_id=<ZONE ID>`

## Inputs

| Name    | Description                                                                 | Type     | Default        | Required |
|---------|-----------------------------------------------------------------------------|----------|----------------|:--------:|
| name    | Common name for all resources.                                              | `string` | `"quantspark"` |    no    |
| zone_id | The ID of the AWS route53 hosted zone you want to use with this deployment. | `string` | `""`           |   yes    |



## Outputs

| Name | Description                           |
|------|---------------------------------------|
| url  | The URL for the website you deployed. |

