# Multiple Storage Integrations Example

This example demonstrates how to create multiple Snowflake storage integrations for AWS S3 using the module.

## Usage

```hcl
module "storage_integrations" {
  source = "../.."

  storage_integration_configs = {
    "raw_data_integration" = {
      name                      = "SN_RAW_DATA_INTEGRATION"
      enabled                   = true
      storage_provider          = "S3"
      storage_aws_role_arn      = "arn:aws:iam::123456789012:role/snowflake-raw-role"
      storage_allowed_locations = ["s3://my-bucket/raw/"]
      storage_blocked_locations = []
      comment                   = "Storage integration for raw data ingestion"
    }
    "processed_data_integration" = {
      name                      = "SN_PROCESSED_DATA_INTEGRATION"
      enabled                   = true
      storage_provider          = "S3"
      storage_aws_role_arn      = "arn:aws:iam::123456789012:role/snowflake-processed-role"
      storage_allowed_locations = ["s3://my-bucket/processed/"]
      storage_blocked_locations = []
      comment                   = "Storage integration for processed data"
    }
    "archive_integration" = {
      name                      = "SN_ARCHIVE_INTEGRATION"
      enabled                   = true
      storage_provider          = "S3"
      storage_aws_role_arn      = "arn:aws:iam::123456789012:role/snowflake-archive-role"
      storage_allowed_locations = ["s3://my-bucket/archive/"]
      storage_blocked_locations = ["s3://my-bucket/archive/restricted/"]
      comment                   = "Storage integration for archived data"
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

After applying this example, configure each AWS IAM role trust policy using the corresponding output values:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "<storage_integration_aws_iam_user_arns[key] output>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<storage_integration_aws_external_ids[key] output>"
        }
      }
    }
  ]
}
```
