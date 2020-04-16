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
  description = "Bucket to use for artifacts"
  type = object({
    id  = string
    arn = string
  })
  default = {
    id  = ""
    arn = ""
  }
}

variable "description" {
  default     = "Managed by Terraform"
  type        = string
  description = "(Optional) The description of the all resources."
}

variable "destination_account" {
  description = "(Optional) Main AWS Account ID."
  default     = "012345678900"
}
