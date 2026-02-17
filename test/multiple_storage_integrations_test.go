// -----------------------------------------------------------------------------
// Terraform Snowflake Storage Integration Module - Multiple Integrations Test
// -----------------------------------------------------------------------------
// Tests creating multiple storage integrations via the module.
// -----------------------------------------------------------------------------

package test

import (
	"fmt"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestMultipleStorageIntegrations tests creating multiple storage integrations via the module
func TestMultipleStorageIntegrations(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToUpper(random.UniqueId())

	si1Name := fmt.Sprintf("TT_RAW_%s", unique)
	si2Name := fmt.Sprintf("TT_PROCESSED_%s", unique)
	si3Name := fmt.Sprintf("TT_ARCHIVE_%s", unique)

	tfDir := "../examples/multiple_storage_integrations"

	storageIntegrationConfigs := map[string]interface{}{
		"raw_integration": map[string]interface{}{
			"name":                      si1Name,
			"enabled":                   true,
			"storage_provider":          "S3",
			"storage_aws_role_arn":      "arn:aws:iam::123456789012:role/snowflake-raw-role",
			"storage_allowed_locations": []string{"s3://test-bucket/raw/"},
			"storage_blocked_locations": []string{},
			"comment":                   "Terratest raw data storage integration",
		},
		"processed_integration": map[string]interface{}{
			"name":                      si2Name,
			"enabled":                   true,
			"storage_provider":          "S3",
			"storage_aws_role_arn":      "arn:aws:iam::123456789012:role/snowflake-processed-role",
			"storage_allowed_locations": []string{"s3://test-bucket/processed/"},
			"storage_blocked_locations": []string{},
			"comment":                   "Terratest processed data storage integration",
		},
		"archive_integration": map[string]interface{}{
			"name":                      si3Name,
			"enabled":                   true,
			"storage_provider":          "S3",
			"storage_aws_role_arn":      "arn:aws:iam::123456789012:role/snowflake-archive-role",
			"storage_allowed_locations": []string{"s3://test-bucket/archive/"},
			"storage_blocked_locations": []string{"s3://test-bucket/archive/restricted/"},
			"comment":                   "Terratest archive storage integration",
		},
	}

	tfOptions := &terraform.Options{
		TerraformDir: tfDir,
		NoColor:      true,
		Vars: map[string]interface{}{
			"storage_integration_configs": storageIntegrationConfigs,
			"snowflake_organization_name": os.Getenv("SNOWFLAKE_ORGANIZATION_NAME"),
			"snowflake_account_name":      os.Getenv("SNOWFLAKE_ACCOUNT_NAME"),
			"snowflake_user":              os.Getenv("SNOWFLAKE_USER"),
			"snowflake_role":              os.Getenv("SNOWFLAKE_ROLE"),
			"snowflake_private_key":       os.Getenv("SNOWFLAKE_PRIVATE_KEY"),
		},
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	time.Sleep(retrySleep)

	db := openSnowflake(t)
	defer func() { _ = db.Close() }()

	// Verify all three storage integrations exist
	for _, siName := range []string{si1Name, si2Name, si3Name} {
		exists := storageIntegrationExists(t, db, siName)
		require.True(t, exists, "Expected storage integration %q to exist in Snowflake", siName)
	}

	// Verify properties of archive integration (has blocked locations)
	props := fetchStorageIntegrationProps(t, db, si3Name)
	require.Equal(t, si3Name, props.Name)
	require.Equal(t, "EXTERNAL_STAGE", props.Type)
	require.Equal(t, "S3", props.StorageProvider)
	require.Contains(t, props.Comment, "Terratest archive storage integration")
}
