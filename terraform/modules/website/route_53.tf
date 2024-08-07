resource "aws_route53_zone" "main_zone" {
  name = "${var.aws_username}-vuejs-test.com"
  comment = "Main zone for ${var.aws_username}-vuejs-test"
}

resource "aws_route53_record" "root_alias" {
  zone_id = aws_route53_zone.main_zone.zone_id
  name = "${var.aws_username}-vuejs-test.com"
  type = "A"

  alias {
    name                   = aws_cloudfront_distribution.website_cloudfront_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.website_cloudfront_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_cname" {
  zone_id = aws_route53_zone.main_zone.zone_id
  name    = "www.${var.aws_username}-vuejs-test.com"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_cloudfront_distribution.website_cloudfront_distribution.domain_name}"]
}

# ACM Certificate

/* resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.domain_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main_zone.zone_id
} */

# Private Certificate Authority

/* resource "aws_route53_record" "private_ca_cname" {
  zone_id  = aws_route53_zone.main_zone.zone_id
  name     = "pca.${var.aws_username}-frontend.com"
  type     = "CNAME"
  ttl      = 300
  records  = ["${var.aws_username}-vuejs-test.com"]
} */
