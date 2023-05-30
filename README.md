# Scheduler LocalStack

Scheduler LocalStack is a sample project that demonstrates how to develop and test AWS Lambda functions locally using Terraform and LocalStack. This project provides an infrastructure setup for deploying a scheduled AWS Lambda function that performs a simple addition operation.

## Prerequisites

Before getting started, make sure you have the following software installed:

- Terraform
- LocalStack
- AWS CLI
- tflocal
- awslocal

## Getting Started

1. Clone this repository: `git clone https://github.com/rahulmlokurte/scheduler-localstack.git`
2. Navigate to the project directory: `cd scheduler-localstack`
3. Start localstack using command `localstack start`

## Deployment

1. Run `tflocal init` to initialize the Terraform environment.
2. Run `tflocal apply` to deploy the infrastructure.

## Verifying the Application

Once the infrastructure is deployed, you can verify the application by following these steps:

1. Run `awslocal --endpoint-url=http://localhost:4566 logs describe-log-groups` to get the log-group
2. Run `awslocal --endpoint-url=http://localhost:4566 logs filter-log-events --log-group-name /aws/lambda/my_lambda_function` to fetch the logs.
3. Verify that we get the message in the logs as `"message": "Sum: 9",`

## Cleaning Up

To clean up and destroy the deployed resources, run `tflocal destroy`.

## Contributing

Contributions are welcome! If you find any issues or want to enhance the project, feel free to submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).

## References

- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [LocalStack Documentation](https://localstack.cloud/docs)
- [AWS CLI Documentation](https://aws.amazon.com/cli/)
- [Terraform Localstack](https://github.com/localstack/terraform-local)
- [AWS CLI Localstack](https://github.com/localstack/awscli-local)

For more details and a step-by-step guide, refer to the [blog post](https://rahullokurte.com/serverless-event-scheduling-with-aws-eventbridge-and-lambda-using-terraform-and-localstack) associated with this project.

