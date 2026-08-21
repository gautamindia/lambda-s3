locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ---------------------------------------------------------------------------
# S3 bucket users upload files into
# ---------------------------------------------------------------------------
module "upload_bucket" {
  source = "./modules/s3-bucket"

  bucket_name        = "${local.name_prefix}-uploads-${var.bucket_suffix}"
  versioning_enabled = true
  force_destroy      = var.force_destroy_buckets
  tags                = local.common_tags
}

# ---------------------------------------------------------------------------
# S3 bucket that receives the processed/result JSON files
# ---------------------------------------------------------------------------
module "results_bucket" {
  source = "./modules/s3-bucket"

  bucket_name        = "${local.name_prefix}-results-${var.bucket_suffix}"
  versioning_enabled = true
  force_destroy      = var.force_destroy_buckets
  tags                = local.common_tags
}

# ---------------------------------------------------------------------------
# IAM role: least privilege for the Lambda function
# ---------------------------------------------------------------------------
module "lambda_role" {
  source = "./modules/iam-role"

  role_name         = "${local.name_prefix}-lambda-role"
  source_bucket_arn = module.upload_bucket.bucket_arn
  dest_bucket_arn   = module.results_bucket.bucket_arn
  tags              = local.common_tags
}

# ---------------------------------------------------------------------------
# Lambda function that processes each uploaded file
# ---------------------------------------------------------------------------
module "file_processor_lambda" {
  source = "./modules/lambda"

  function_name = "${local.name_prefix}-processor"
  role_arn      = module.lambda_role.role_arn
  source_dir    = "${path.root}/src/lambda"
  handler       = "handler.handler"
  runtime       = "python3.12"
  timeout       = 30
  memory_size   = 128

  environment_variables = {
    DEST_BUCKET    = module.results_bucket.bucket_id
    RESULT_PREFIX  = "processed/"
  }

  source_bucket_arn = module.upload_bucket.bucket_arn
  tags              = local.common_tags
}

# ---------------------------------------------------------------------------
# S3 -> Lambda event trigger: fire on every new object created in uploads
# ---------------------------------------------------------------------------
resource "aws_s3_bucket_notification" "upload_trigger" {
  bucket = module.upload_bucket.bucket_id

  lambda_function {
    lambda_function_arn = module.file_processor_lambda.function_arn
    events               = ["s3:ObjectCreated:*"]
  }

  # The S3 service must already have permission to invoke the function
  # before the notification config is created, or this call fails.
  depends_on = [module.file_processor_lambda]
}
