# -----------------------------------------------------------------------------
# Terraform Snowflake Storage Integration Module - Versions
# -----------------------------------------------------------------------------
# Terraform and provider version constraints for the Snowflake storage
# integration module.
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = ">= 1.0.0"
    }
  }
}
