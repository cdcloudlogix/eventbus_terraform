# EC2 Events module

This module provision CloudWatch Event to record EC2 events. These events are then sent to main account with the help  

## Usage

```hcl
module "ec2_events_module" {
  source = "modules/ec2-events"

  create              = true
  name                = "member-ec2-events"
  target_eventbus_arn = "arn:aws:events::${var.destination_account}:event-bus/default"
  iam_role            = var.iam_role_object

  providers = {
    aws = aws.member
  }
}
```

## Cross account cloudwatch events

If you wish to learn more about passing events across multiple aws account, please use this [link](https://aws.amazon.com/blogs/aws/new-cross-account-delivery-of-cloudwatch-events/) for more information.
