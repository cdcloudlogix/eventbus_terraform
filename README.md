# EventBus Terraform

Example of passing AWS CloudWatch Events from one account to another.

## Description

This repository is an example of how to send EC2 notifications with CloudWatch events from one AWS account to another.

## Overview

![Image](EventBus.png?raw=true)

## Usage

This is divided in 2 different parts, one for the main account, one for one of your member account. Keep in mind that EventBus is restricted by region, you will need to this main module for each regions.

### Main Account configuration

Main account module configuration:

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

Use principal variable as follow:

```
variable "principals" {
  description = "(Required) list of AWS Accounts"
  type        = map(string)
  default     = {
    "member-name"  = "012345678901"
    "member-name1" = "012345678902"
  }
}
```

### Member Account configuration

```hcl
module "member_account_events" {
  source = "./modules/ec2-events"

  create     = true
  name       = "main-account-ec2-events"
  principals = var.principals

  providers = {
    aws = "aws.member"
  }
}
```
