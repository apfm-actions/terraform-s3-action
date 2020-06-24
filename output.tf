output "bucket_arn" {
  description = "The ARN of the bucket"
  value = aws_s3_bucket.bucket.arn
}

output "website_endpoint" {
  description = "The website endpoint, if the bucket is configured with a website. If not, this will be an empty string."
  value = aws_s3_bucket.bucket.website_endpoint
}

output "access_policy_arn" {
  description = "The ARN assigned by AWS to this policy"
  value = aws_iam_policy.policy.arn
}
