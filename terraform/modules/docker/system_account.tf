##############
### LOCALS ###
##############

locals {
  system_account_role_managed_policies = [
    # "arn:aws:iam::aws:policy/AdministratorAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
  ]
}

resource "aws_iam_policy" "user_assume_role_policy" {
  name        = "${var.application_name}-assume-role-policy"
  description = "Policy to allow user to assume the GitHub Actions role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/github-actions-role"  # Substitua pelo ARN correto
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_user_assume_role_policy" {
  user       = var.aws_username
  policy_arn = aws_iam_policy.user_assume_role_policy.arn
}

################
### ROLES ###
################

data "aws_iam_policy_document" "system_account_assume_role_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.aws_username}"]
    }
  }

  statement {
    effect = "Allow"
    actions = ["sts:TagSession"]

    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.aws_username}"]
    }
  }
}

resource "aws_iam_role" "github_actions_role" {
  name               = "${var.application_name}-github-actions-role"
  assume_role_policy = data.aws_iam_policy_document.system_account_assume_role_policy.json
}

#############################
### POLICIES ATTACHMENTS ###
#############################

resource "aws_iam_role_policy_attachment" "system_account_assume_role_policy_attachment" {
  role       = aws_iam_role.github_actions_role.name
  count      = length(local.system_account_role_managed_policies)
  policy_arn = local.system_account_role_managed_policies[count.index]
  depends_on = [aws_iam_role.github_actions_role]
}

resource "aws_iam_policy" "github_actions_policy" {
  name        = "GitHubActionsPolicy"
  description = "Policy for GitHub Actions to access AWS resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_github_actions_policy" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_policy.arn
}
