data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_route53_zone" "zone" {
  zone_id = var.zone_id
}

data "aws_iam_policy_document" "oai" {
  version = "2012-10-17"

  statement {
    sid     = "originAccessIdentity"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    principals {
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
      type        = "AWS"
    }

    resources = ["${aws_s3_bucket.web.arn}/*"]
  }
}
