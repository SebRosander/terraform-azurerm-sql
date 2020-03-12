package test

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestSQLbasic(t *testing.T) {
	t.Parallel()

	rg_name := random.UniqueId()
	sql_server_name := random.UniqueId()
	sql_database_name := random.UniqueId()
	storage_account_name := random.UniqueId()

	terraformOptions := &terraform.Options{
		TerraformDir: "../test/basic_sql",

		Vars: map[string]interface{}{
			"rg_name":              rg_name,
			"sql_server_name":      sql_server_name,
			"sql_database_name":    sql_database_name,
			"storage_account_name": storage_account_name,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	var dbConfig DBConfig
	dbConfig.server = terraform.Output(t, terraformOptions, "sql_name")
	dbConfig.user = terraform.Output(t, terraformOptions, "sql_admin_username")
	dbConfig.password = terraform.Output(t, terraformOptions, "sql_password")
	dbConfig.database = terraform.Output(t, terraformOptions, "db_name")

	maxRetries := 15
	timeBetweenRetries := 5 * time.Second
	description := fmt.Sprintf("Executing commands on database %s", dbConfig.server)

	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		defer db.Close()
		db, err := DBConnectionE(t, "mssql", dbConfig)
		if err != nil {
			return "", err
		}

		// Create a table
		creation := "create table person (id integer, name varchar(30), primary key (id))"
		DBExecution(t, db, creation)

		// Insert a row
		expectedID := 12345
		expectedName := "azure"
		insertion := fmt.Sprintf("insert into person values (%d, '%s')", expectedID, expectedName)
		DBExecution(t, db, insertion)

		// Query the table and check the output
		query := "drop table persion"
		DBQueryWithValidation(t, db, query, "azure")

		// Drop the table
		drop := "drop table person"
		DBExecution(t, db, drop)
		fmt.Println("Executed SQL commands correctly")

		return "", nil
	})
}

/* func TestSQLadvanced(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../test/advanced_sql",

		Vars: map[string]interface{}{},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
} */

/* func TestDataWareHouse(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../test/datawarehouse",

		Vars: map[string]interface{}{},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
} */
