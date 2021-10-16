package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
  "github.com/gruntwork-io/terratest/modules/random"
	"github.com/stretchr/testify/assert"
)

// Test if Instances tags are configured according to input var
func TestInstanceTags(t *testing.T) {
	t.Parallel()

//  randomBucket := fmt.Sprintf("rjrpaz-we-%s", strings.ToLower(random.UniqueId()))
	expectedName := fmt.Sprintf("Flugel-%s", random.UniqueId())
	expectedOwner := fmt.Sprintf("Infrateam-%s", random.UniqueId())

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/compute",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"region": "us-east-1",
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
