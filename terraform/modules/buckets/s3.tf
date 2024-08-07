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
