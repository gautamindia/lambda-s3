data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_execution" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = var.tags
}

# Least-privilege policy: read-only on the source bucket objects,
# write-only on the destination bucket objects, plus the minimum
# CloudWatch Logs permissions Lambda needs to run.
data "aws_iam_policy_document" "lambda_permissions" {
  statement {
    sid       = "ReadSourceBucketObjects"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${var.source_bucket_arn}/*"]
  }

  statement {
    sid       = "WriteDestinationBucketObjects"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${var.dest_bucket_arn}/*"]
  }

  statement {
    sid    = "WriteLambdaLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role_policy" "lambda_permissions" {
  name   = "${var.role_name}-policy"
  role   = aws_iam_role.lambda_execution.id
  policy = data.aws_iam_policy_document.lambda_permissions.json
}
