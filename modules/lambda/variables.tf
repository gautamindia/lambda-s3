variable "function_name" {
  description = "Name of the Lambda function."
  type        = string
}

variable "role_arn" {
  description = "ARN of the IAM role the Lambda function will assume."
  type        = string
}

variable "source_dir" {
  description = "Path to the directory containing the Lambda source code to zip."
  type        = string
}

variable "handler" {
  description = "Lambda handler, e.g. handler.handler for handler.py's `handler` function."
  type        = string
  default     = "handler.handler"
}

variable "runtime" {
  description = "Lambda runtime."
  type        = string
  default     = "python3.12"
}

variable "timeout" {
  description = "Lambda timeout in seconds."
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Lambda memory size in MB."
  type        = number
  default     = 128
}

variable "environment_variables" {
  description = "Environment variables to pass to the Lambda function."
  type        = map(string)
  default     = {}
}

variable "source_bucket_arn" {
  description = "ARN of the S3 bucket allowed to invoke this function."
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention period in days."
  type        = number
  default     = 14
}

variable "tags" {
  description = "Tags to apply to the Lambda function."
  type        = map(string)
  default     = {}
}
