variable "destination_account" {
  description = "(Optional) Main AWS Account ID."
  default     = "0123456789010"
}

variable "principals" {
  description = "(Required) list of AWS Accounts"
  type        = map(string)
  default     = {
    "member-name"  = "012345678901"
    "member-name1" = "012345678902"
  }
}
