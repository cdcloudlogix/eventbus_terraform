# AWS EventBus EC2 SQS module

This module provide the necessary to create and SQS queue and link EC2 events

## Usage

```hcl
module "main_account_events" {
  source = "./modules/eventbus-sqs"

  create     = true
  name       = "main-account-ec2-events"
  principals = var.principals

  providers = {
    aws = "aws.main"
  }
}
```

```
variable "principals" {
  description = "(Required) list of AWS Accounts"
  type        = map(string)
  default     = {
    "member-name"  = "0123456789011"
    "member-name1" = "0123456789012"
  }
}
```

## Across account cloudwatch events

If you wish to learn more about passing events across multiple aws account, please use this [link](https://aws.amazon.com/blogs/aws/new-cross-account-delivery-of-cloudwatch-events/) for more information.
