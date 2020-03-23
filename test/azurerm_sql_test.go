package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/random"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func test(t *testing.T, directory string) {
	x := random.UniqueId()
	x = strings.ToLower(x)

	terraformOptions := &terraform.Options{
		TerraformDir: directory,

		Vars: map[string]interface{}{
			"rg_name":	fmt.Sprintf("resource-group-%s", x),
			"sql_database_name": fmt.Sprintf("dbname-%s", x),
			"sql_server_name": fmt.Sprintf("server-name-%s", x),
			"storage_account_name": fmt.Sprintf("storageaccount%s", x),
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	var dbConfig DBConfig
	dbConfig.server = terraform.Output(t, terraformOptions, "sql_fully_qualified_domain_name")
	dbConfig.user = terraform.Output(t, terraformOptions, "sql_admin_username")
	dbConfig.password = terraform.Output(t, terraformOptions, "sql_password")
	dbConfig.database = terraform.Output(t, terraformOptions, "db_name")
	dbConfig.port = 1433

	// It can take a minute or so for the database to boot up, so retry a few times
	maxRetries := 15
	timeBetweenRetries := 5 * time.Second
	description := fmt.Sprintf("Executing commands on database %s", dbConfig.server)

	// Verify that we can connect to the database and run SQL commands
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		// Connect to specific database, i.e. mssql
		db, err := DBConnectionE(t, "sqlserver", dbConfig)
		if err != nil {
			return "", err
		}

		fmt.Println("Connected")

		// Create a table
		creation := "create table person (id integer, name varchar(30), primary key (id))"
		DBExecution(t, db, creation)

		fmt.Println("Created Table")

		// Insert a row
		expectedID := 12345
		expectedName := "azure"
		insertion := fmt.Sprintf("insert into person values (%d, '%s')", expectedID, expectedName)
		DBExecution(t, db, insertion)

		fmt.Println("Inserted Row")

		// Query the table and check the output
		query := "select name from person"
		DBQueryWithValidation(t, db, query, "azure")

		fmt.Println("Query Table")

		// Drop the table
		drop := "drop table person"
		DBExecution(t, db, drop)
		fmt.Println("Executed SQL commands correctly")

		defer db.Close()

		return "", nil
	})

}

func TestSQLBasic(t *testing.T) {
	t.Parallel()
	test(t, "./basic_sql")

}

func TestSQLAdvanced(t *testing.T) {
	t.Parallel()
	test(t, "./advanced_sql")
}

func TestSQLDatawarehouse(t *testing.T) {
	t.Parallel()
	test(t, "./datawarehouse")
}
