################
### POLICIES ###
################


# data "aws_iam_policy_document" "ecr_kms_policy" {
  # statement {
  #   sid       = "Enable IAM User Permissions"
  #   effect    = "Allow"
  #   actions   = ["kms:*"]
  #   resources = ["*"]

  #   principals {
  #     type        = "AWS"
  #     identifiers = ["arn:aws:sts::${data.aws_caller_identity.current.account_id}:user/${var.aws_username}"]
  #   }
  # }

  # statement {
  #   sid       = "Allow access for Key Administrators"
  #   effect    = "Allow"
  #   actions   = [
  #     "kms:Create*",
  #     "kms:Describe*",
  #     "kms:Enable*",
  #     "kms:List*",
  #     "kms:Put*",
  #     "kms:Update*",
  #     "kms:Revoke*",
  #     "kms:Disable*",
  #     "kms:Get*",
  #     "kms:Delete*",
  #     "kms:TagResource",
  #     "kms:UntagResource",
  #     "kms:ScheduleKeyDeletion",
  #     "kms:CancelKeyDeletion"
  #   ]
  #   resources = ["*"]

  #   principals {
  #     type        = "AWS"
  #     identifiers = ["arn:aws:sts::${data.aws_caller_identity.current.account_id}:user/${var.aws_username}"]
  #   }
  # }

#   statement {
#     sid       = "Allow key usage"
#     effect    = "Allow"
#     actions   = [
#       "kms:Encrypt",
#       "kms:Decrypt",
#       "kms:ReEncrypt",
#       "kms:GenerateDataKey*",
#       "kms:DescribeKey"
#     ]
#     resources = ["*"]

#     principals {
#       type        = "AWS"
#       identifiers = [aws_iam_role.ecr_role.arn]
#     }
#   }

#   statement {
#     sid       = "Allow persistent resources attachment"
#     effect    = "Allow"
#     actions   = [
#       "kms:CreateGrant",
#       "kms:ListGrants",
#       "kms:RevokeGrant"
#     ]
#     resources = ["*"]

#     principals {
#       type        = "AWS"
#       identifiers = [aws_iam_role.ecr_role.arn]
#     }

#     condition {
#       test    = "StringLike"
#       variable = "kms:GrantIsForAWSResource"
#       values   = ["true"]
#     }
#   }
# }

############
### KEYS ###
############

resource "aws_kms_key" "ecr_kms_key" {
  description = "Key for encryption purposes in ECR"
  enable_key_rotation = true
  depends_on = [aws_iam_role.ecr_role]

  timeouts {
    create = "30m"
  }
}

# resource "aws_kms_key_policy" "ecr_kms_key_policy" {
#   key_id = aws_kms_key.ecr_kms_key.key_id
#   policy = data.aws_iam_policy_document.ecr_kms_policy.json
# }

resource "aws_kms_alias" "ecr_kms_key_alias" {
  name = "alias/ecr-kms-key"
  target_key_id = aws_kms_key.ecr_kms_key.key_id
}
