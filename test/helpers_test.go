// File: test/helpers_test.go
package test

import (
	"crypto/rsa"
	"crypto/x509"
	"database/sql"
	"encoding/pem"
	"fmt"
	"os"
	"strings"
	"testing"

	"github.com/snowflakedb/gosnowflake"
	"github.com/stretchr/testify/require"
)

type StorageIntegrationProps struct {
	Name                 string
	Type                 string
	Enabled              string
	StorageProvider      string
	StorageAwsIamUserArn string
	StorageAwsExternalId string
	Comment              string
}

func openSnowflake(t *testing.T) *sql.DB {
	t.Helper()

	orgName := mustEnv(t, "SNOWFLAKE_ORGANIZATION_NAME")
	accountName := mustEnv(t, "SNOWFLAKE_ACCOUNT_NAME")
	user := mustEnv(t, "SNOWFLAKE_USER")
	privateKeyPEM := mustEnv(t, "SNOWFLAKE_PRIVATE_KEY")
	role := os.Getenv("SNOWFLAKE_ROLE")

	// Parse the private key
	block, _ := pem.Decode([]byte(privateKeyPEM))
	require.NotNil(t, block, "Failed to decode PEM block from private key")

	var privateKey *rsa.PrivateKey
	var err error

	// Try PKCS8 first, then PKCS1
	key, err := x509.ParsePKCS8PrivateKey(block.Bytes)
	if err != nil {
		privateKey, err = x509.ParsePKCS1PrivateKey(block.Bytes)
		require.NoError(t, err, "Failed to parse private key")
	} else {
		var ok bool
		privateKey, ok = key.(*rsa.PrivateKey)
		require.True(t, ok, "Private key is not RSA")
	}

	// Build account identifier: orgname-accountname
	account := fmt.Sprintf("%s-%s", orgName, accountName)

	config := gosnowflake.Config{
		Account:       account,
		User:          user,
		Authenticator: gosnowflake.AuthTypeJwt,
		PrivateKey:    privateKey,
	}

	if role != "" {
		config.Role = role
	}

	dsn, err := gosnowflake.DSN(&config)
	require.NoError(t, err, "Failed to build DSN")

	db, err := sql.Open("snowflake", dsn)
	require.NoError(t, err)
	require.NoError(t, db.Ping())
	return db
}

func storageIntegrationExists(t *testing.T, db *sql.DB, integrationName string) bool {
	t.Helper()

	q := fmt.Sprintf("SHOW STORAGE INTEGRATIONS LIKE '%s';", escapeLike(integrationName))
	rows, err := db.Query(q)
	require.NoError(t, err)
	defer func() { _ = rows.Close() }()

	return rows.Next()
}

func fetchStorageIntegrationProps(t *testing.T, db *sql.DB, integrationName string) StorageIntegrationProps {
	t.Helper()

	q := fmt.Sprintf("SHOW STORAGE INTEGRATIONS LIKE '%s';", escapeLike(integrationName))
	rows, err := db.Query(q)
	require.NoError(t, err)
	defer func() { _ = rows.Close() }()

	cols, err := rows.Columns()
	require.NoError(t, err)

	// Find column indices
	nameIdx, typeIdx, enabledIdx, commentIdx := -1, -1, -1, -1
	for i, col := range cols {
		switch col {
		case "name":
			nameIdx = i
		case "type":
			typeIdx = i
		case "enabled":
			enabledIdx = i
		case "comment":
			commentIdx = i
		}
	}
	require.NotEqual(t, -1, nameIdx, "name column not found in SHOW STORAGE INTEGRATIONS output")
	require.NotEqual(t, -1, typeIdx, "type column not found in SHOW STORAGE INTEGRATIONS output")
	require.NotEqual(t, -1, enabledIdx, "enabled column not found in SHOW STORAGE INTEGRATIONS output")
	require.NotEqual(t, -1, commentIdx, "comment column not found in SHOW STORAGE INTEGRATIONS output")

	require.True(t, rows.Next(), "No storage integration found matching %s", integrationName)

	// Create slice to hold all column values
	values := make([]interface{}, len(cols))
	valuePtrs := make([]interface{}, len(cols))
	for i := range values {
		valuePtrs[i] = &values[i]
	}

	err = rows.Scan(valuePtrs...)
	require.NoError(t, err)

	// Extract the values we need
	getName := func(v interface{}) string {
		if v == nil {
			return ""
		}
		if s, ok := v.(string); ok {
			return s
		}
		if b, ok := v.([]byte); ok {
			return string(b)
		}
		return fmt.Sprintf("%v", v)
	}

	props := StorageIntegrationProps{
		Name:    getName(values[nameIdx]),
		Type:    getName(values[typeIdx]),
		Enabled: getName(values[enabledIdx]),
		Comment: getName(values[commentIdx]),
	}

	// Get additional properties from DESCRIBE
	descQ := fmt.Sprintf("DESCRIBE STORAGE INTEGRATION %s;", integrationName)
	descRows, err := db.Query(descQ)
	require.NoError(t, err)
	defer func() { _ = descRows.Close() }()

	for descRows.Next() {
		var property, propertyType, propertyValue, propertyDefault string
		err = descRows.Scan(&property, &propertyType, &propertyValue, &propertyDefault)
		require.NoError(t, err)

		switch property {
		case "STORAGE_PROVIDER":
			props.StorageProvider = propertyValue
		case "STORAGE_AWS_IAM_USER_ARN":
			props.StorageAwsIamUserArn = propertyValue
		case "STORAGE_AWS_EXTERNAL_ID":
			props.StorageAwsExternalId = propertyValue
		}
	}

	return props
}

func mustEnv(t *testing.T, key string) string {
	t.Helper()
	v := strings.TrimSpace(os.Getenv(key))
	require.NotEmpty(t, v, "Missing required environment variable %s", key)
	return v
}

func escapeLike(s string) string {
	return strings.ReplaceAll(s, "'", "''")
}
