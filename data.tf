data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_route53_zone" "zone" {
  zone_id = var.zone_id
}

data "aws_iam_policy_document" "oac_web_bucket_policy_document" {
  version = "2012-10-17"

  statement {
    sid     = "OriginAccessControl"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }

    resources = ["${aws_s3_bucket.web.arn}/*"]

    condition {
      test     = "StringEquals"
      values   = [aws_cloudfront_distribution.dist.arn]
      variable = "AWS:SourceArn"
    }
  }
}
