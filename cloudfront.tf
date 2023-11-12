resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = var.name
  description                       = "Ensure users cannot access the site using the S3 url"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "dist" {
  enabled             = true
  aliases             = [local.site_name]
  default_root_object = "index.html"
  web_acl_id          = aws_wafv2_web_acl.waf_acl.arn

  // "All" is the most broad distribution, and also the most expensive.
  // "100" is the least broad (USA, Canada and Europe), and also the least expensive.
  price_class = "PriceClass_100"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = aws_s3_bucket.web.arn
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    compress    = true
    min_ttl     = 0
    default_ttl = 1000
    max_ttl     = 86400
  }

  origin {
    domain_name              = aws_s3_bucket.web.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.web.arn
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }

  logging_config {
    bucket          = aws_s3_bucket.logs.bucket_domain_name
    include_cookies = false
    prefix          = "${local.site_name}/"
  }
}
