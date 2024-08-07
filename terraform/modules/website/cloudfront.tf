resource "aws_cloudfront_distribution" "website_cloudfront_distribution" {
  origin {
    domain_name = aws_s3_bucket.www_bucket.bucket_regional_domain_name
    origin_id = "S3Origin"
  }

  enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id = "S3Origin"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["HEAD", "GET", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl = 0
    default_ttl = 86400
    max_ttl = 31536000
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "website_cloudfront_origin_access_identity" {
  comment = "CloudFront Origin Access Identity for ${aws_cloudfront_distribution.website_cloudfront_distribution.domain_name}"
}
