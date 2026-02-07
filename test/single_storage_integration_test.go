// File: test/single_storage_integration_test.go
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

// TestSingleStorageIntegration tests creating a single storage integration via the module
func TestSingleStorageIntegration(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToUpper(random.UniqueId())
	integrationName := fmt.Sprintf("TT_SI_%s", unique)

	tfDir := "../examples/single_storage_integration"

	storageIntegrationConfigs := map[string]interface{}{
		"test_integration": map[string]interface{}{
			"name":                      integrationName,
			"enabled":                   true,
			"storage_provider":          "S3",
			"storage_aws_role_arn":      "arn:aws:iam::123456789012:role/snowflake-test-role",
			"storage_allowed_locations": []string{"s3://test-bucket/data/"},
			"storage_blocked_locations": []string{},
			"comment":                   "Terratest single storage integration test",
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

	exists := storageIntegrationExists(t, db, integrationName)
	require.True(t, exists, "Expected storage integration %q to exist in Snowflake", integrationName)

	props := fetchStorageIntegrationProps(t, db, integrationName)
	require.Equal(t, integrationName, props.Name)
	require.Equal(t, "EXTERNAL_STAGE", props.Type)
	require.Equal(t, "true", props.Enabled)
	require.Equal(t, "S3", props.StorageProvider)
	require.Contains(t, props.Comment, "Terratest single storage integration test")
}
