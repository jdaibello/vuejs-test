resource "aws_cloudfront_distribution" "website_cloudfront_distribution" {
  origin {
    domain_name = aws_s3_bucket.www_bucket.bucket_regional_domain_name
    origin_id = "S3Origin"
  }

  enabled             = true
  comment             = "CloudFront Distribution for www.${var.aws_username}-vuejs-test.com"
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id       = "S3Origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["HEAD", "GET", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # viewer_certificate {
  #   acm_certificate_arn = aws_acm_certificate.private_domain_certificate.arn
  #   ssl_support_method  = "sni-only"
  # }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # aliases = [
  #   "www.${var.aws_username}-vuejs-test.com",
  #   "${var.aws_username}-vuejs-test.com"
  # ]

  tags = {
    Project = "Frontend"
  }
}

resource "aws_cloudfront_origin_access_identity" "website_cloudfront_origin_access_identity" {
  comment = "CloudFront Origin Access Identity for ${aws_cloudfront_distribution.website_cloudfront_distribution.domain_name}"
}
