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

## Usage with Grants

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
      comment                   = "Storage integration for raw data ingestion"
      grants = [
        {
          role_name  = "DATA_ENGINEER"
          privileges = ["USAGE"]
        },
        {
          role_name  = "DATA_ANALYST"
          privileges = ["USAGE"]
        }
      ]
    }
    "processed_data_integration" = {
      name                      = "SN_PROCESSED_DATA_INTEGRATION"
      enabled                   = true
      storage_provider          = "S3"
      storage_aws_role_arn      = "arn:aws:iam::123456789012:role/snowflake-processed-role"
      storage_allowed_locations = ["s3://my-bucket/processed/"]
      comment                   = "Storage integration for processed data"
      grants = [
        {
          role_name  = "DATA_ENGINEER"
          privileges = ["USAGE"]
        }
      ]
    }
  }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| storage_integration_configs | Map of storage integration configuration objects | map(object) | yes |

### storage_integration_configs Object Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| name | string | - | Storage integration name (required) |
| enabled | bool | true | Whether the integration is enabled |
| storage_provider | string | "S3" | Cloud storage provider |
| storage_aws_role_arn | string | - | AWS IAM role ARN (required for S3) |
| storage_allowed_locations | list(string) | - | Allowed bucket paths (required) |
| storage_blocked_locations | list(string) | [] | Blocked bucket paths |
| comment | string | null | Description |
| grants | list(object) | [] | Role grants configuration |

### grants Object Properties

| Property | Type | Description |
|----------|------|-------------|
| role_name | string | Snowflake role name |
| privileges | list(string) | Privileges to grant (e.g., ["USAGE"]) |

## Outputs

| Name | Description |
|------|-------------|
| storage_integration_names | The names of the created storage integrations |
| aws_storage_integrations | AWS storage integration resources |

## AWS IAM Configuration

After applying this example, configure each AWS IAM role trust policy using the corresponding output values:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "<storage_aws_iam_user_arn from describe_output>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<storage_aws_external_id from describe_output>"
        }
      }
    }
  ]
}
```
