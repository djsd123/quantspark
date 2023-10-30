resource "aws_route53_record" "cert_validation_sans" {
  for_each = {
    for domain_validation in aws_acm_certificate.cert.domain_validation_options : domain_validation.domain_name => {
      name    = domain_validation.resource_record_name
      records = domain_validation.resource_record_value
      type    = domain_validation.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
  ttl             = 60

  records = [each.value.records]
}

resource "aws_route53_record" "cloudfront_alias" {
  name    = local.site_name
  type    = "A"
  zone_id = data.aws_route53_zone.zone.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_cloudfront_distribution.dist.domain_name
    zone_id                = aws_cloudfront_distribution.dist.hosted_zone_id
  }
}