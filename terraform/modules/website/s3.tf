# www frontend bucket
resource "aws_s3_bucket" "www_bucket" {
  bucket   = "www.test-joao-daibello-frontend-website"

  tags = {
    Project = "test-joao-daibello-frontend-website"
  }
}

resource "aws_s3_bucket_cors_configuration" "www_aws_cors" {
  bucket = aws_s3_bucket.www_bucket.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["POST", "PUT", "GET", "DELETE"]
    allowed_origins = ["https://www.${aws_s3_bucket.www_bucket.bucket}.com"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_website_configuration" "www_bucket_website" {
  bucket = aws_s3_bucket.www_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "www_bucket_policy" {
  bucket = aws_s3_bucket.www_bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*", # public access
        Action    = "s3:ListBucket",
        Resource  = ["arn:aws:s3:::${aws_s3_bucket.www_bucket.bucket}"]
      },
      {
        Effect    = "Allow",
        Principal = "*", # public access
        Action    = ["s3:GetObject", "s3:PutObject"],
        Resource  = ["arn:aws:s3:::${aws_s3_bucket.www_bucket.bucket}/*"]
      }
    ]
  })
}

# root frontend bucket
resource "aws_s3_bucket" "root_bucket" {
  bucket = "test-joao-daibello-frontend-website"

  tags = {
    Project = "test-joao-daibello-frontend-website"
  }
}

resource "aws_s3_bucket_policy" "root_bucket_policy" {
  bucket = aws_s3_bucket.root_bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*", # public access
        Action    = "s3:ListBucket",
        Resource  = ["arn:aws:s3:::${aws_s3_bucket.root_bucket.bucket}"]
      },
      {
        Effect    = "Allow",
        Principal = "*", # public access
        Action    = ["s3:GetObject", "s3:PutObject"],
        Resource  = ["arn:aws:s3:::${aws_s3_bucket.root_bucket.bucket}/*"]
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "root_bucket_website" {
  bucket = aws_s3_bucket.root_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
