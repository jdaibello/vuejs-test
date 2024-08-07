resource "aws_route53_zone" "main_zone" {
  name = "${var.aws_username}-vuejs-test.com"
  comment = "Main zone for ${var.aws_username}-vuejs-test"
}

resource "aws_route53_record" "www_cname" {
  zone_id = aws_route53_zone.main_zone.zone_id
  name = "www.${var.aws_username}-vuejs-test.com"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_cloudfront_distribution.website_cloudfront_distribution.domain_name}"]
}
