# tfstate bucket
resource "aws_s3_bucket" "tfstate_remote_storage" {
  bucket = "test-joao-daibello-frontend-terraform-state"

  tags = {
    Project = "frontend"
  }
}

resource "aws_s3_bucket_versioning" "tfstate_storage_versioning" {
  bucket                = aws_s3_bucket.tfstate_remote_storage.id
  expected_bucket_owner = data.aws_caller_identity.current.account_id

  versioning_configuration {
    status = "Enabled"
  }
}

# www frontend bucket
resource "aws_s3_bucket" "www_bucket" {
  bucket = "www.test-joao-daibello-frontend-website"

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

############
### DATA ###
############

data "aws_iam_policy_document" "tfstate_bucket_policy" {
  statement {
    actions   = ["s3:CreateBucket"]
    resources = [aws_s3_bucket.tfstate_remote_storage.arn]
  }

  statement {
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["${aws_s3_bucket.tfstate_remote_storage.arn}/terraform.tfstate"]
    effect    = "Allow"
  }
}
