locals {
  site_name  = "${var.name}.${data.aws_route53_zone.zone.name}"
  bucket_ids = [aws_s3_bucket.web.id, aws_s3_bucket.logs.id]
}

resource "aws_s3_bucket" "web" {
  bucket        = local.site_name
  force_destroy = true
}

resource "aws_s3_bucket" "logs" {
  bucket        = "${local.site_name}-logs"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "web_oai" {
  bucket = aws_s3_bucket.web.id
  policy = data.aws_iam_policy_document.oai.json
}

resource "aws_s3_bucket_website_configuration" "web_config" {
  bucket = aws_s3_bucket.web.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "web_pub_access_block" {
  count = length(local.bucket_ids)

  bucket                  = local.bucket_ids[count.index]
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on              = [aws_s3_bucket.web, aws_s3_bucket.logs]
}

resource "aws_s3_bucket_ownership_controls" "web_controls" {
  count = length(local.bucket_ids)

  bucket = local.bucket_ids[count.index]

  rule {
    object_ownership = "BucketOwnerPreferred"
  }

  depends_on = [aws_s3_bucket.web, aws_s3_bucket.logs]
}

resource "aws_s3_object" "html" {
  for_each = fileset("${path.module}/www", "*.html")

  bucket       = aws_s3_bucket.web.id
  key          = each.value
  source       = "${path.module}/www/${each.value}"
  content_type = "text/html"
  etag         = filemd5("${path.module}/www/${each.value}")
}

resource "aws_s3_object" "gif" {
  for_each = fileset("${path.module}/www", "*.gif")

  bucket       = aws_s3_bucket.web.id
  key          = each.value
  source       = "${path.module}/www/${each.value}"
  content_type = "image/gif"
  etag         = filemd5("${path.module}/www/${each.value}")
}
