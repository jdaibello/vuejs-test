resource "aws_cloudfront_distribution" "website_cloudfront_distribution" {
  origin {
    domain_name = aws_s3_bucket.www_bucket.bucket_regional_domain_name
    origin_id   = "S3Origin"
  }

  origin {
    domain_name = var.backend_alb_url
    origin_id   = "CustomOriginConfig"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
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

  ordered_cache_behavior {
    path_pattern           = "/posts*"
    target_origin_id       = "CustomOriginConfig"
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["HEAD", "GET", "OPTIONS", "POST", "PUT", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
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
