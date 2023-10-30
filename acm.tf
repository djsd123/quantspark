resource "aws_acm_certificate" "cert" {
  domain_name       = data.aws_route53_zone.zone.name
  validation_method = "DNS"

  subject_alternative_names = ["*.${data.aws_route53_zone.zone.name}"]

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.aws-us-east-1
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.cert.arn

  validation_record_fqdns = [
    for validation_record in aws_route53_record.cert_validation_sans : validation_record.fqdn
  ]

  provider = aws.aws-us-east-1
}
