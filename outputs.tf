output "upload_bucket_name" {
  description = "Name of the bucket users upload files into."
  value       = module.upload_bucket.bucket_id
}

output "results_bucket_name" {
  description = "Name of the bucket where processed results are stored."
  value       = module.results_bucket.bucket_id
}

output "lambda_function_name" {
  description = "Name of the deployed Lambda function."
  value       = module.file_processor_lambda.function_name
}

output "lambda_function_arn" {
  description = "ARN of the deployed Lambda function."
  value       = module.file_processor_lambda.function_arn
}

output "lambda_role_arn" {
  description = "ARN of the Lambda's IAM execution role."
  value       = module.lambda_role.role_arn
}
