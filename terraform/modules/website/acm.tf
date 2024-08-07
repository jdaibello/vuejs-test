# ACM Certificate

/* resource "aws_acm_certificate" "domain_certificate" {
  domain_name = "${var.aws_username}-vuejs-test.com"
  validation_method = "DNS"

  tags = {
    Name    = "${var.aws_username}-vuejs-test.com"
    Project = "Frontend"
  }
}

resource "aws_acm_certificate_validation" "domain_certificate_validation" {
  certificate_arn = aws_acm_certificate.domain_certificate.arn

  validation_record_fqdns = [
    for dvo in aws_acm_certificate.domain_certificate.domain_validation_options : aws_route53_record.certificate_validation[dvo.domain_name].fqdn
  ]

  timeouts {
    create = "30m"
  }
} */

# Private Certificate Authority

/* resource "aws_acmpca_certificate_authority" "domain_private_ca" {
  usage_mode = "SHORT_LIVED_CERTIFICATE"

  certificate_authority_configuration {
    key_algorithm = "RSA_2048"
    signing_algorithm = "SHA256WITHRSA"

    subject {
      country = "${var.ca_country}"
      locality = "${var.ca_locality}"
      organization = "${var.ca_organization}"
      common_name = "${var.aws_username}-vuejs-test.com"
    }
  }

  tags = {
    Project = "Frontend"
  }
}

resource "aws_acm_certificate" "private_domain_certificate" {
  domain_name = "${var.aws_username}-vuejs-test.com"

  certificate_authority_arn = aws_acmpca_certificate_authority.domain_private_ca.arn

  tags = {
    Name    = "${var.aws_username}-vuejs-test.com"
    Project = "Frontend"
  }
}

resource "aws_acm_certificate_validation" "domain_certificate_validation" {
  certificate_arn = aws_acm_certificate.domain_certificate.arn

  validation_record_fqdns = [
    for dvo in aws_acm_certificate.domain_certificate.domain_validation_options : aws_route53_record.certificate_validation[dvo.domain_name].fqdn
  ]

  timeouts {
    create = "30m"
  }
} */
