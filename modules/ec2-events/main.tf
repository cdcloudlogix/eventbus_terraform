# -----------------------------------------------------------
# set up AWS Cloudwatch Event rule for EC2 events
# -----------------------------------------------------------

resource "aws_cloudwatch_event_rule" "ec2_events" {
  count = var.create ? 1 : 0

  name        =  "${var.name}-events"
  description = var.description

  event_pattern = <<PATTERN
{
  "source": [
    "aws.autoscaling"
  ],
  "detail-type": [
    "EC2 Instance Launch Successful",
    "EC2 Instance Terminate Successful",
    "EC2 Instance Launch Unsuccessful",
    "EC2 Instance Terminate Unsuccessful"
  ]
}
PATTERN
}

# -------------------------------------------------------------
# set up AWS Cloudwatch Event to target the default eventbus
# -------------------------------------------------------------

resource "aws_cloudwatch_event_target" "event_target" {
  count = var.create ? 1 : 0

  rule      = aws_cloudwatch_event_rule.ec2_events[0].id
  target_id = "${var.name}-eventbus"
  arn       = var.target_eventbus_arn
  role_arn  = aws_iam_role.default[0].arn
}

resource "aws_iam_role" "default" {
  count = var.create ? 1 : 0

  name                  = "${var.name}-cloudwatch-role"
  force_detach_policies = true

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# -------------------------------------------------------------
# Create a data IAM Policy to allow PutsEvents
# -------------------------------------------------------------

data "aws_iam_policy_document" "eventbus_policy" {
  count = var.create ? 1 : 0

  statement {
    sid    = "AssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [var.iam_role.arn]
  }

  statement {
    sid    = "CloudwatchAccess"
    effect = "Allow"

    actions = [
      "events:PutEvents"
    ]

    resources = [var.target_eventbus_arn]
  }
}


# -------------------------------------------------------------
# Link IAM Policy to IAM role
# -------------------------------------------------------------

resource "aws_iam_role_policy" "cloudwatch_policy" {
  count = var.create ? 1 : 0

  name   = "${var.name}-role"
  role   = aws_iam_role.default[0].id
  policy = data.aws_iam_policy_document.eventbus_policy[0].json
}
