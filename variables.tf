variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Short name used as a prefix for all resource names."
  type        = string
  default     = "file-processor"
}

variable "environment" {
  description = "Deployment environment name (e.g. dev, staging, production)."
  type        = string
  default     = "dev"
}

# Bucket names must be globally unique across all of AWS, so a suffix
# (e.g. your AWS account ID) is required. Pass this via -var or a
# .tfvars file / CI variable.
variable "bucket_suffix" {
  description = "Unique suffix appended to bucket names (e.g. AWS account ID) to satisfy S3's global bucket-name uniqueness requirement."
  type        = string
}

variable "force_destroy_buckets" {
  description = "Allow buckets to be destroyed even if they contain objects. Keep false in production."
  type        = bool
  default     = false
}
