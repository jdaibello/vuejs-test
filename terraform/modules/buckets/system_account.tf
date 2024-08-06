#############
### ROLES ###
#############

resource "aws_iam_role" "s3_frontend_role" {
  name = "test-joao-daibello-s3-bucket-frontend-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

################
### POLICIES ###
################

resource "aws_iam_policy" "s3_frontend_policy" {
  name        = "test-joao-daibello-s3-bucket-frontend-policy"
  description = "Policy to allow creating S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "s3:ListBucket",
        Resource = ["${aws_s3_bucket.tfstate_remote_storage.arn}"]
      },
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject", "s3:PutObject"],
        Resource = ["${aws_s3_bucket.tfstate_remote_storage.arn}/terraform.tfstate"]
      }
    ]
  })
}

resource "aws_iam_policy" "dynamodb_frontend_state_locking_policy" {
  name        = "test-joao-daibello-dynamodb-frontend-state-locking-policy"
  description = "Policy to allow locking the state file in DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ],
        Resource = ["${aws_dynamodb_table.terraform_state_frontend_locking_table.arn}"]
      }
    ]
  })
}

#############################
### POLICIES ATTACHEMENTS ###
#############################

resource "aws_iam_role_policy_attachment" "s3_create_bucket_attachment" {
  role       = aws_iam_role.s3_frontend_role.name
  policy_arn = aws_iam_policy.s3_frontend_policy.arn
}

resource "aws_iam_role_policy_attachment" "dynamodb_table_attachment" {
  role       = aws_iam_role.s3_frontend_role.name
  policy_arn = aws_iam_policy.dynamodb_frontend_state_locking_policy.arn
}
