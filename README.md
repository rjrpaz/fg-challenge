# fg-challenge

Flugel technical challenge.

## Requirements

### TEST 1

- Create Terraform code to create an S3 bucket and an EC2 instance. Both resources must be tagged with Name=Flugel, Owner=InfraTeam.
- Using Terratest, create the test automation for the Terraform code, validating that both resources are tagged properly.
- Setup Github Actions to run a pipeline to validate this code.
- Publish your code in a public GitHub repository, and share a Pull Request with your code. Do not merge into master until the PR is approved.
- Include documentation describing the steps to run and test the automation.

### TEST 2

Complete the test #1 + the following actions:

- Merge any pending PR.
- Create a new PR with code and updated documentation for the new requirement.
- Create a cluster of 2 EC2 instances behind an ALB running Nginx, serving a static file. This static file must be generated at boot, using a Python script. Put the AWS instance tags in the file.
- The cluster must be deployed in a new VPC. This VPC must have only one public subnet. Do not use default VPC
- Update the tests to validate the infrastructure. The test must check that files are reachable in the ALB.

## Terraform code to create S3 bucket and EC2 instance

References:

- [https://registry.terraform.io/providers/hashicorp/aws/latest/docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)

Create Terraform code to create an S3 bucket and an EC2 instance. Both resources must be tagged with *Name=Flugel*, *Owner=InfraTeam*.

Configure any custom AWS variable in **terraform.tfvars** file (you can use *terraform.tfvars.sample* as reference). If not, default values will be used. A word of caution, however: S3 name are globally unique so there script will probably not work if you use default values for the bucket name.

1. *terraform plan/apply* will require aws credentials to run. It is recommended to provide these credentials as *environment variables* like this:

    ```console
    export AWS_ACCESS_KEY_ID="anaccesskey"
    export AWS_SECRET_ACCESS_KEY="asecretkey"
    ```

1. Initialize terraform:

    ```console
    terraform init
    ```

1. Run terraform plan to check if there is something missing:

    ```console
    terraform plan
    ```

1. Apply terraform:

    ```console
    terraform apply --auto-approve
    ```

An s3 bucket and a EC2 instance should be created.

## Automate test of the Terraform code with Terratest

References:

- [https://terratest.gruntwork.io/docs/](https://terratest.gruntwork.io/docs/)

Using *Terratest*, create the test automation for the Terraform code, validating that both resources are tagged properly.

*test* directory includes the testing code for Terratest.

1. Change to *test* directory:

    ```console
    cd test
    ```

1. Initializa terratest for the modules

    ```console
    go mod init "modules"
    go mod tidy
    ```

1. Run the test

    ```console
    go test -v -timeout 30m
    ```

1. Both test will run in parallel. You should get "PASS" messages, like these:

    ```console
       ...
    TestS3Tags 2021-10-16T18:18:17-04:00 logger.go:66: Destroy complete! Resources: 1 destroyed.
    --- PASS: TestS3Tags (47.42s)
       ...
    --- PASS: TestInstanceTags (117.24s)
    PASS
    ok      modules 117.243s
    ```

## Run terratest from Github action

References:

- [https://dev.to/mnsanfilippo/testing-iac-with-terratest-and-github-actions-okh](https://dev.to/mnsanfilippo/testing-iac-with-terratest-and-github-actions-okh)

Setup Github Actions to run a pipeline to validate this code.

To use this from Github actions, required AWS credentials should be configured as secrets in the repository.

![Configure secrets](./images/git-secrets.PNG)

This is the content of the workflow used for the action:

```yaml
name: Testing AWS resource tags
on:
push:
    branches:
    - tf-s3-ec2
pull_request:
    branches:
    - tf-s3-ec2
    -
jobs:
test:
    runs-on: ubuntu-latest
    env:
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

    steps:
    - uses: actions/checkout@v2
    - name: Set up Go
      uses: actions/setup-go@v2
      with:
        go-version: 1.17

    - name: Setup Dependencies
      working-directory: test/
      run:  go get -v -t -d && go mod tidy

    - name: Test
      working-directory: test/
      run: go test -v
```

## Publish your code in a public GitHub repository

Publish your code in a public GitHub repository, and share a Pull Request with your code. Do not merge into master until the PR is approved.

You are in the Github repository right now.

GH Pull request: [https://github.com/rjrpaz/fg-challenge/pull/1](https://github.com/rjrpaz/fg-challenge/pull/1)

## Include documentation

Include documentation describing the steps to run and test the automation.

Being this a fully automated test, only required step is to commit new code to a specific branch to run the test.

It is recommended to include the development branchs where the test is going to run in the github actions workflow: [.github/workflows/check_tag.yml](.github/workflows/check_tag.yml)

```yaml
   ...
name: Testing AWS resource tags
on:
push:
    branches:
    - tf-s3-ec2
    - add-your-own-branch-here
pull_request:
    branches:
    - tf-s3-ec2
    - add-your-own-branch-here
    -
   ...
```

## Merge any pending PR

Merge any pending PR done: [https://github.com/rjrpaz/fg-challenge/pull/1](https://github.com/rjrpaz/fg-challenge/pull/1)

## Create a new PR with code and updated documentation for this stage

Create a new PR with code and updated documentation for the new requirement.

In my case I will use two separated branches (one for the code and the other for the documentation).

## Create a cluster of 2 EC2 instances behind an ALB

Create a cluster of 2 EC2 instances behind an ALB running Nginx, serving a static file. This static file must be generated at boot, using a Python script. Put the AWS instance tags in the file.

The cluster must be deployed in a new VPC. This VPC must have only one public subnet. Do not use default VPC.

References:

- [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
- [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)
- [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)
- [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)
- [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table)
- [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)
- [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)
- [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group)
- [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener)

This is the list of required resources:

1. A new VPC.

1. Two public subnets, one for each instance.

1. An internet gateway

1. A route table

1. A default route, linked to the route table and the internet gateway

1. A default route table

1. A security group

After this, each EC2 instance should be created using the previously created resources.

Regarding application load balancer, required resources are:

1. An ALB

1. A target group for the ALB

1. An ALB listener

### Steps to create the infrastructure

Steps are pretty much the same than before:

1. *terraform plan/apply* will require aws credentials to run. It is recommended to provide these credentials as *environment variables* like this:

    ```console
    export AWS_ACCESS_KEY_ID="anaccesskey"
    export AWS_SECRET_ACCESS_KEY="asecretkey"
    ```

1. Initialize terraform:

    ```console
    terraform init
    ```

1. Run terraform plan to check if there is something missing:

    ```console
    terraform plan
    ```

1. Apply terraform:

    ```console
    terraform apply --auto-approve
    ```

1. If code applied succesfully, output will show a message like this:

    ```console
       ...
    Apply complete! Resources: 19 added, 0 changed, 0 destroyed.

    Outputs:

    instance-name = [
    [
        "Flugel-0",
        "Flugel-1",
    ],
    ]
    instance-owner = [
    [
        "InfraTeam",
        "InfraTeam",
    ],
    ]
    instance-public_ip = [
    [
        "3.95.149.26",
        "54.211.129.15",
    ],
    ]
    lb_endpoint = "loadbalancer-1076895768.us-east-1.elb.amazonaws.com"
    public_sg = "sg-0f71b90e67340788b"
    public_subnets = [
    "subnet-012a93d78669cdc2c",
    "subnet-08a00a3d0d59790fe",
    ]
    s3-name = [
    "Flugel",
    ]
    s3-owner = [
    "InfraTeam",
    ]
    ```

    (variables may vary)

1. Test reachability to the instances

    According to the *instance-public-ip* output returned in previous step, you can check if default page is accesible on each instance, p.e.:

    ```console
    curl 3.95.149.26
    ```

    should return something like this:

    ```console
    Hello from i-0acc268ad6f017900
    ```

1. Test reachability to the load balancer

    You can also test reachability to the ALB endpoint using the returned *lb_endpoint* value, p.e.:

    ```console
    curl loadbalancer-1076895768.us-east-1.elb.amazonaws.com
    ```

    Run this command a few times and note that the ALB returns the default page for both instances in round-robin, like this:

    ```console
    [roberto@vmlab01 fg-challenge]$ curl loadbalancer-1076895768.us-east-1.elb.amazonaws.com
    Hello from i-09c31c92a7f42443a
    [roberto@vmlab01 fg-challenge]$ curl loadbalancer-1076895768.us-east-1.elb.amazonaws.com
    Hello from i-0acc268ad6f017900
    ```

## TODO

- Add additional testing steps to check web reachability to the ABL.
- Add some other tools to do static linting and vulnerability checking to the terraform code as part of the github actions.
