resource "aws_kms_key" "rds_kms_key" {
  description = "KMS key for RDS encryption"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "rds.amazonaws.com"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.aws_username}"
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF
}
