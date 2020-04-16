output "sqs_event_queue_arn" {
  value = concat(aws_sqs_queue.events_queue.*.arn, [""])[0]
}

output "sqs_event_queue_id" {
  value = concat(aws_sqs_queue.events_queue.*.id, [""])[0]
}

output "assume_role" {
  value = {
    id  = concat(aws_iam_role.assume_role.*.id, [""])[0]
    arn = concat(aws_iam_role.assume_role.*.arn, [""])[0]
  }
}
