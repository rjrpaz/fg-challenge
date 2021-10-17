package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
  "github.com/gruntwork-io/terratest/modules/random"
	"github.com/stretchr/testify/assert"
)

// Test if S3 tags are configured according to input var
func TestS3Tags(t *testing.T) {
	t.Parallel()

  randomBucket := fmt.Sprintf("rjrpaz-fg-%s", strings.ToLower(random.UniqueId()))
	expectedName := fmt.Sprintf("Flugel-%s", random.UniqueId())
	expectedOwner := fmt.Sprintf("Infrateam-%s", random.UniqueId())

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/storage",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"region": "us-east-1",
			"bucket": randomBucket,
			"name": expectedName,
			"owner": expectedOwner,
		},

		NoColor: true,
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	actualName := terraform.Output(t, terraformOptions, "name")
	actualOwner := terraform.Output(t, terraformOptions, "owner")

	// Verify we're getting back the outputs we expect
	assert.Equal(t, expectedName, actualName)
	assert.Equal(t, expectedOwner, actualOwner)
}

