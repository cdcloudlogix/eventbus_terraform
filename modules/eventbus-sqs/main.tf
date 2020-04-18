#################################################################
# Cloudwatch config
#################################################################

resource "aws_cloudwatch_event_permission" "accounts" {
  for_each = var.principals

  principal    = each.value
  statement_id = each.key
}

resource "aws_cloudwatch_event_rule" "event_rule" {
  count       = var.create ? 1 : 0
  name        = "${var.name}-events"
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

resource "aws_sqs_queue_policy" "events_queue_policy" {
  count = var.create ? 1 : 0

  queue_url = aws_sqs_queue.events_queue[0].id
  policy    = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.events_queue[0].arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_cloudwatch_event_rule.event_rule[0].arn}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_cloudwatch_event_target" "event_target" {
  count = var.create ? 1 : 0

  rule      = aws_cloudwatch_event_rule.event_rule[0].id
  target_id = "${var.name}-sqs"
  arn       = aws_sqs_queue.events_queue[0].arn
}

resource "aws_sqs_queue" "events_queue" {
  count = var.create ? 1 : 0

  name = "${var.name}-ec2-finding-events"
}

#################################################################
# Cross Account IAM role
#################################################################

data "aws_iam_policy_document" "assume_policy" {
  count = var.create ? 1 : 0

  dynamic "statement" {
    for_each = var.principals

    content {
      actions = ["sts:AssumeRole"]

      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${statement.value}:root"]
      }
    }
  }

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudwatch_access_policy" {
  count = var.create ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "events:PutEvents"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "cloudwatch_access_policy" {
  count = var.create ? 1 : 0

  name        = "${var.name}-cloudwatch-access"
  policy      = data.aws_iam_policy_document.cloudwatch_access_policy[0].json
  path        = var.iam_path
  description = var.description
}

resource "aws_iam_role_policy_attachment" "across_attach" {
  count = var.create ? 1 : 0

  role       = aws_iam_role.assume_role[0].name
  policy_arn = aws_iam_policy.cloudwatch_access_policy[0].arn
}


# IAM Role
resource "aws_iam_role" "assume_role" {
  count = var.create ? 1 : 0

  name               = "${var.name}-assume-role"
  assume_role_policy = data.aws_iam_policy_document.assume_policy[0].json
  path               = var.iam_path
  description        = var.description
}
