resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  acl           = var.enable_website ? "public-read" : var.acl
  policy        = var.bucket_policy
  force_destroy = var.force_destroy

  dynamic "website" {
    for_each = var.enable_website ? ["1"] : []

    content {
      index_document           = var.website_redirect != "" ? null : var.website_index_document
      error_document           = var.website_error_document
      redirect_all_requests_to = var.website_redirect != "" ? var.website_redirect : null
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

resource "aws_s3_bucket_policy" "public_read_policy" {
  count = var.enable_website ? 1 : 0

  bucket = aws_s3_bucket.bucket.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "${aws_s3_bucket.bucket.arn}/*"
            ]
        }
    ]
}
POLICY
}
