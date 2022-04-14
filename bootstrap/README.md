This module will be executed only once to setup terraform backend to store infrastructure state
It will create -
1. S3 bucket: [aws_account_id]-[aws_region]-tfstate
2. Dynamo DB table for state locking: [environment]-[aws_region]-lock-table

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.9.0 |

## Prerequisite
Please ensure you have installed following tools - 
* make
* [tfsec](https://github.com/liamg/tfsec)
* [tflint](https://github.com/terraform-linters/tflint)
* terraform

Set following environment variables:
ENV: Name of environment
REGION: AWS region where you want to deploy the resources
AWS_PROFILE: AWS profile
```
make
apply                          Have terraform do the things. This will cost money.
check-security                 Static analysis of your terraform templates to spot potential security issues.
destroy                        Destroy the things
documentation                  Generate README.md for a module
format                         Rewrites all Terraform configuration files to a canonical format.
lint                           Check for possible errors, best practices, etc in current directory!
plan-destroy                   Creates a destruction plan.
plan                           Show what terraform thinks it will do
prep                           Prepare a new workspace (environment) if needed, configure the tfstate backend, update any modules, and switch to the workspace

```
To do terraform plan: 
```
ENV=dev REGION=eu-central-1 AWS_PROFILE=temp_mob-bp-dng make plan
```
To do terraform apply:
```
ENV=dev REGION=eu-central-1 AWS_PROFILE=temp_mob-bp-dng make apply
```
To do terraform destroy:
```
ENV=dev REGION=eu-central-1 AWS_PROFILE=temp_mob-bp-dng make destroy
```

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.dynamodb-terraform-state-lock](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_s3_bucket.terraform-state-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.block_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.state-bucket-encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.state-bucket-versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.state-bucket-policy-doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | AWS region name | `any` | n/a | yes |
| <a name="input_dynamo_lock_table"></a> [dynamo\_lock\_table](#input\_dynamo\_lock\_table) | Name of dynamo table | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS profile name | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket-name"></a> [bucket-name](#output\_bucket-name) | Bucket name |
| <a name="output_dynamo-db-name"></a> [dynamo-db-name](#output\_dynamo-db-name) | Dynamo db name |
