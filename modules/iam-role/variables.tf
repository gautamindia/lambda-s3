variable "role_name" {
  description = "Name for the Lambda execution IAM role."
  type        = string
}

variable "source_bucket_arn" {
  description = "ARN of the S3 bucket Lambda is allowed to read objects from."
  type        = string
}

variable "dest_bucket_arn" {
  description = "ARN of the S3 bucket Lambda is allowed to write result objects to."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the IAM role."
  type        = map(string)
  default     = {}
}
