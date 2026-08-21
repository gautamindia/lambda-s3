"""
S3 -> Lambda file processor.

Triggered when a new file is uploaded to the source S3 bucket.
Steps:
  1. Get bucket name and key (file name) from the event.
  2. Use boto3 to read the file from S3 using that bucket name and key.
  3. Print the file name and size.
  4. Upload the file to another (destination) S3 bucket.
"""

import os
import urllib.parse

import boto3

s3 = boto3.client("s3")

DEST_BUCKET = os.environ["DEST_BUCKET"]


def handler(event, context):
    for record in event["Records"]:
        # 1. Get bucket name and key from the event
        source_bucket = record["s3"]["bucket"]["name"]
        key = urllib.parse.unquote_plus(record["s3"]["object"]["key"])

        # 2. Use bucket name and key to read the file from S3
        response = s3.get_object(Bucket=source_bucket, Key=key)
        file_content = response["Body"].read()
        file_size = len(file_content)

        # 3. Print file name and size
        print(f"File name: {key}")
        print(f"File size: {file_size} bytes")

        # 4. Upload the same file to another S3 bucket
        s3.put_object(
            Bucket=DEST_BUCKET,
            Key=key,
            Body=file_content,
        )

        print(f"File uploaded to s3://{DEST_BUCKET}/{key}")