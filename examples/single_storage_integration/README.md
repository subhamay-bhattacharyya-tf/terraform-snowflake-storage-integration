# Single Storage Integration Example

This example demonstrates how to create a single Snowflake storage integration for AWS S3 using the module.

## Usage

```hcl
module "storage_integration" {
  source = "../../modules/snowflake-storage-integration"

  storage_integration_configs = {
    "my_integration" = {
      name                      = "MY_S3_INTEGRATION"
      enabled                   = true
      storage_provider          = "S3"
      storage_aws_role_arn      = "arn:aws:iam::123456789012:role/snowflake-role"
      storage_allowed_locations = ["s3://my-bucket/data/"]
      storage_blocked_locations = []
      comment                   = "My S3 storage integration"
    }
  }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| storage_integration_configs | Map of storage integration configuration objects | map(object) | yes |

## Outputs

| Name | Description |
|------|-------------|
| storage_integration_names | The names of the created storage integrations |
| storage_integration_aws_iam_user_arns | The AWS IAM user ARNs for the storage integrations |
| storage_integration_aws_external_ids | The AWS external IDs for the storage integrations |
| storage_integrations | All storage integration resources |

## AWS IAM Configuration

After applying this example, use the output values to configure your AWS IAM role trust policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "<storage_integration_aws_iam_user_arns output>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<storage_integration_aws_external_ids output>"
        }
      }
    }
  ]
}
```
