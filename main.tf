# Main Account
module "main_account_events" {
  source = "./modules/eventbus-sqs"

  create     = true
  name       = "main-account-ec2-events"
  principals = var.principals

  providers = {
    aws = aws.main
  }
}

# Member Account
module "ec2_events_module" {
  source = "./modules/ec2-events"

  create              = true
  name                = "member-ec2-events"
  target_eventbus_arn = "arn:aws:events::${var.destination_account}:event-bus/default"
  iam_role            = module.main_account_events.assume_role

  providers = {
    aws = aws.member
  }
}
