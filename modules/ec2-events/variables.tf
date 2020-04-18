variable "name" {
  description = "(Required) Resource naming"
}

variable "create" {
  description = "Whether to create these resources or not"
  default     = false
}

variable "target_eventbus_arn" {
  description = "(Required) AWS Resource Event Bus arn."
}

variable "iam_role" {
  description = "Main IAM role to assume"
  type = object({
    id  = string
    arn = string
  })
  default = {
    id  = ""
    arn = ""
  }
}

variable "destination_account" {
  description = "(Optional) Main AWS Account ID."
  default     = "012345678900"
}

variable "description" {
  default     = "Managed by Terraform"
  type        = string
  description = "(Optional) The description of the all resources."
}
