resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = var.acl
  policy = var.bucket_policy
  region = var.region

  dynamic "website" {
    for_each = var.enable_website ? [] : ["1"]

    content {
      index_document           = var.website_index_document
      error_document           = var.website_error_document
      redirect_all_requests_to = var.website_redirect
    }
  }

  tags = {
    app   = var.project_name
    owner = var.project_owner
    env   = terraform.workspace
    repo  = var.github_repository
  }
}

resource "aws_iam_policy" "policy" {
  name        = "s3-${aws_s3_bucket.bucket.id}-RW-Access"
  description = "RW Access to S3 bucket. ${var.github_repository}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.bucket.arn}",
        "${aws_s3_bucket.bucket.arn}/*"
      ]
    }
  ]
}
POLICY
}
