# Terraform Snowflake Module - Storage Integration

![Release](https://github.com/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration/actions/workflows/ci.yaml/badge.svg)&nbsp;![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?logo=snowflake&logoColor=white)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/cc141ddcec28756e7f9071c265ce1a73/raw/terraform-snowflake-storage-integration.json?)

A Terraform module for creating and managing Snowflake storage integrations using a map of configuration objects. Supports creating single or multiple storage integrations for AWS S3 with a single module call.

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
  source = "path/to/modules/snowflake-storage-integration"

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
locals {
  storage_integrations = {
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

module "storage_integrations" {
  source = "path/to/modules/snowflake-storage-integration"

  storage_integration_configs = local.storage_integrations
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
| storage_aws_role_arn | string | - | AWS IAM role ARN for S3 access (required) |
| storage_allowed_locations | list(string) | - | List of allowed S3 bucket paths (required) |
| storage_blocked_locations | list(string) | [] | List of blocked S3 bucket paths |
| comment | string | null | Description of the storage integration |

### Valid Storage Providers

- S3 (Amazon S3)
- GCS (Google Cloud Storage)
- AZURE (Azure Blob Storage)

## Outputs

| Name | Description |
|------|-------------|
| storage_integration_names | Map of storage integration names keyed by identifier |
| storage_integration_aws_iam_user_arns | Map of AWS IAM user ARNs created by Snowflake |
| storage_integration_aws_external_ids | Map of AWS external IDs for trust policy configuration |
| storage_integrations | All storage integration resources |

## AWS IAM Configuration

After creating a storage integration, you need to configure the AWS IAM role trust policy using the outputs:

```hcl
# Get the Snowflake IAM user ARN and external ID from outputs
output "snowflake_iam_user_arn" {
  value = module.storage_integration.storage_integration_aws_iam_user_arns["my_integration"]
}

output "snowflake_external_id" {
  value = module.storage_integration.storage_integration_aws_external_ids["my_integration"]
}
```

Update your IAM role trust policy:

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
- Invalid AWS IAM role ARN format

## Testing

The module includes Terratest-based integration tests:

```bash
cd test
go mod tidy
go test -v -timeout 30m
```

Required environment variables for testing:
- `SNOWFLAKE_ORGANIZATION_NAME` - Snowflake organization name
- `SNOWFLAKE_ACCOUNT_NAME` - Snowflake account name
- `SNOWFLAKE_USER` - Snowflake username
- `SNOWFLAKE_ROLE` - Snowflake role (e.g., "ACCOUNTADMIN")
- `SNOWFLAKE_PRIVATE_KEY` - Snowflake private key for key-pair authentication

## CI/CD Configuration

The CI workflow runs on:
- Push to `main`, `feature/**`, and `bug/**` branches (when `modules/**` changes)
- Pull requests to `main` (when `modules/**` changes)
- Manual workflow dispatch

The workflow includes:
- Terraform validation and format checking
- Examples validation
- Terratest integration tests (output displayed in GitHub Step Summary)
- Changelog generation (non-main branches)
- Semantic release (main branch only)

The CI workflow uses the following GitHub organization variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `TERRAFORM_VERSION` | Terraform version for CI jobs | `1.3.0` |
| `GO_VERSION` | Go version for Terratest | `1.21` |
| `SNOWFLAKE_ORGANIZATION_NAME` | Snowflake organization name | - |
| `SNOWFLAKE_ACCOUNT_NAME` | Snowflake account name | - |
| `SNOWFLAKE_USER` | Snowflake username | - |
| `SNOWFLAKE_ROLE` | Snowflake role (e.g., ACCOUNTADMIN) | - |

The following GitHub secrets are required for Terratest integration tests:

| Secret | Description | Required |
|--------|-------------|----------|
| `SNOWFLAKE_PRIVATE_KEY` | Snowflake private key for key-pair authentication | Yes |

## License

MIT License - See [LICENSE](LICENSE) for details.
