# Single Storage Integration Example

This example demonstrates how to create a single Snowflake storage integration for AWS S3 using the module.

## Usage

```hcl
module "storage_integration" {
  source = "../.."

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

## Usage with Grants

```hcl
module "storage_integration" {
  source = "../.."

  storage_integration_configs = {
    "my_integration" = {
      name                      = "MY_S3_INTEGRATION"
      enabled                   = true
      storage_provider          = "S3"
      storage_aws_role_arn      = "arn:aws:iam::123456789012:role/snowflake-role"
      storage_allowed_locations = ["s3://my-bucket/data/"]
      comment                   = "My S3 storage integration"
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

After applying this example, use the output values to configure your AWS IAM role trust policy:

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
