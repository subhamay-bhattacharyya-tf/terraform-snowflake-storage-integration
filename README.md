# Terraform Snowflake Storage Integration

![Release](https://github.com/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration/actions/workflows/ci.yaml/badge.svg)&nbsp;![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?logo=snowflake&logoColor=white)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/cc141ddcec28756e7f9071c265ce1a73/raw/terraform-snowflake-storage-integration.json?)

A Terraform module for creating and managing Snowflake storage integrations using a map of configuration objects. Supports creating single or multiple storage integrations for AWS S3, GCS, and Azure with a single module call.

## Features

- Map-based configuration for creating single or multiple storage integrations
- Provider-specific resources for AWS S3, GCS, and Azure
- Built-in role-based access grants configuration
- Built-in input validation with descriptive error messages
- Sensible defaults for optional properties
- Outputs keyed by integration identifier for easy reference
- Configurable allowed and blocked storage locations

## Usage

### Single Storage Integration (AWS S3)

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

### Storage Integration with Grants

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
      comment                   = "My S3 storage integration"
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
      grants = [
        {
          role_name  = "DATA_ENGINEER"
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
    }
  }
}
```

### Azure Storage Integration

```hcl
module "azure_storage_integration" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-snowflake-storage-integration"

  storage_integration_configs = {
    "azure_integration" = {
      name                      = "MY_AZURE_INTEGRATION"
      enabled                   = true
      storage_provider          = "AZURE"
      azure_tenant_id           = "your-azure-tenant-id"
      storage_allowed_locations = ["azure://myaccount.blob.core.windows.net/mycontainer/"]
      comment                   = "Azure Blob storage integration"
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

## Examples

- [Single Storage Integration](examples/single_storage_integration) - Create a single AWS S3 storage integration
- [Multiple Storage Integrations](examples/multiple_storage_integrations) - Create multiple AWS S3 storage integrations

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| snowflake | >= 1.0.0 |

## Providers

| Name | Version |
|------|---------|
| snowflake | >= 1.0.0 |

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
| azure_tenant_id | string | null | Azure tenant ID (required for AZURE) |
| storage_allowed_locations | list(string) | - | List of allowed bucket paths (required) |
| storage_blocked_locations | list(string) | [] | List of blocked bucket paths |
| comment | string | null | Description of the storage integration |
| grants | list(object) | [] | List of role grants for the storage integration |

### grants Object Properties

| Property | Type | Description |
|----------|------|-------------|
| role_name | string | Name of the Snowflake role to grant privileges to |
| privileges | list(string) | List of privileges to grant (e.g., ["USAGE"]) |

## Outputs

| Name | Description |
|------|-------------|
| storage_integration_names | Map of storage integration names keyed by identifier |
| aws_storage_integrations | All AWS storage integration resources |
| gcs_storage_integrations | All GCS storage integration resources |
| azure_storage_integrations | All Azure storage integration resources |

## AWS IAM Configuration

After creating a storage integration, access the AWS IAM user ARN and external ID from the `aws_storage_integrations` output:

```hcl
output "snowflake_iam_user_arn" {
  value = module.storage_integration.aws_storage_integrations["my_integration"].describe_output[0].storage_aws_iam_user_arn[0].value
}

output "snowflake_external_id" {
  value = module.storage_integration.aws_storage_integrations["my_integration"].describe_output[0].storage_aws_external_id[0].value
}
```

Configure the AWS IAM role trust policy:

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
- Missing azure_tenant_id (when using AZURE)

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
