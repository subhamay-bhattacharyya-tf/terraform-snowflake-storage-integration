# Terraform Snowflake Storage Integration

![Release](https://github.com/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration/actions/workflows/ci.yaml/badge.svg)&nbsp;![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?logo=snowflake&logoColor=white)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/cc141ddcec28756e7f9071c265ce1a73/raw/terraform-snowflake-storage-integration.json?)

A Terraform module for creating and managing Snowflake storage integrations using a map of configuration objects. Supports creating single or multiple storage integrations for AWS S3, GCS, and Azure with a single module call.

## Features

- Map-based configuration for creating single or multiple storage integrations
- Built-in input validation with descriptive error messages
- Sensible defaults for optional properties
- Outputs keyed by integration identifier for easy reference
- Support for AWS S3, GCS, and Azure storage providers
- Configurable allowed and blocked storage locations

## Usage

### Single Storage Integration

```hcl
module "storage_integration" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration"

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

### Multiple Storage Integrations

```hcl
module "storage_integrations" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration"

  storage_integration_configs = {
    "raw_data_integration" = {
      name                      = "SN_RAW_DATA_INTEGRATION"
      enabled                   = true
      storage_provider          = "S3"
      storage_aws_role_arn      = "arn:aws:iam::123456789012:role/snowflake-raw-role"
      storage_allowed_locations = ["s3://my-bucket/raw/"]
      comment                   = "Storage integration for raw data ingestion"
    }
    "processed_data_integration" = {
      name                      = "SN_PROCESSED_DATA_INTEGRATION"
      enabled                   = true
      storage_provider          = "S3"
      storage_aws_role_arn      = "arn:aws:iam::123456789012:role/snowflake-processed-role"
      storage_allowed_locations = ["s3://my-bucket/processed/"]
      comment                   = "Storage integration for processed data"
    }
  }
}
```

## Examples

- [Single Storage Integration](examples/single_storage_integration) - Create a single storage integration
- [Multiple Storage Integrations](examples/multiple_storage_integrations) - Create multiple storage integrations

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| snowflake | >= 0.87.0 |

## Providers

| Name | Version |
|------|---------|
| snowflake | >= 0.87.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| storage_integration_configs | Map of configuration objects for Snowflake storage integrations | `map(object)` | `{}` | no |

### storage_integration_configs Object Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| name | string | - | Storage integration identifier (required) |
| enabled | bool | true | Whether the integration is enabled |
| storage_provider | string | "S3" | Cloud storage provider (S3, GCS, AZURE) |
| storage_aws_role_arn | string | null | AWS IAM role ARN for S3 access (required for S3) |
| storage_allowed_locations | list(string) | - | List of allowed bucket paths (required) |
| storage_blocked_locations | list(string) | [] | List of blocked bucket paths |
| comment | string | null | Description of the storage integration |

## Outputs

| Name | Description |
|------|-------------|
| storage_integration_names | Map of storage integration names keyed by identifier |
| storage_integration_aws_iam_user_arns | Map of AWS IAM user ARNs created by Snowflake |
| storage_integration_aws_external_ids | Map of AWS external IDs for trust policy configuration |
| storage_integrations | All storage integration resources |

## AWS IAM Configuration

After creating a storage integration, configure the AWS IAM role trust policy using the outputs:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "<STORAGE_AWS_IAM_USER_ARN>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<STORAGE_AWS_EXTERNAL_ID>"
        }
      }
    }
  ]
}
```

## Validation

The module validates inputs and provides descriptive error messages for:

- Empty storage integration name
- Invalid storage provider
- Empty storage_allowed_locations
- Invalid AWS IAM role ARN format (when using S3)

## Testing

The module includes Terratest-based integration tests:

```bash
cd test
go mod tidy
go test -v -timeout 30m
```

Required environment variables:
- `SNOWFLAKE_ORGANIZATION_NAME`
- `SNOWFLAKE_ACCOUNT_NAME`
- `SNOWFLAKE_USER`
- `SNOWFLAKE_ROLE`
- `SNOWFLAKE_PRIVATE_KEY`

## License

MIT License - See [LICENSE](LICENSE) for details.
