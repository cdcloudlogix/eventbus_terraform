variable "principals" {
  description = "(Required) list of AWS Accounts"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "(Required) The resource's name."
}

variable "iam_path" {
  default     = "/"
  type        = string
  description = "(Optional) Path in which to create the IAM Role and the IAM Policy."
}

variable "description" {
  default     = "Managed by Terraform"
  type        = string
  description = "(Optional) The description of the all resources."
}

variable "create" {
  description = "(Optional) Whether to create these resources or not"
  default     = false
}

variable "target_eventbus_arn" {
  default = ""
}
