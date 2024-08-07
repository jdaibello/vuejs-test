##############
### LOCALS ###
##############

locals {
  ecr_repositories = [
    "frontend"
  ]
}

###########
### IAM ###
###########

# ECR Policies
data "aws_iam_policy_document" "ecr_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = [ "sts:AssumeRole" ]

    principals {
      type        = "Service"
      identifiers = ["ecr.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecr_repository_policy" {
  statement {
    effect        = "Allow"
    actions       = [
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetDownloadUrlForLayers",
      "ecr:GetRepositoryPolicy",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:SetRepositoryPolicy",
      "ecr:UploadLayerPart",
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.ecr_role.arn]
    }
  }
}

# ECR Role
resource "aws_iam_role" "ecr_role" {
  name               = "${var.application_name}-ecr-role"
  assume_role_policy = data.aws_iam_policy_document.ecr_assume_role_policy.json
  path               = "/"
}

####################
### REPOSITORIES ###
####################

resource "aws_ecr_repository" "ecr_repository" {
  count = length(local.ecr_repositories)
  name  = "${var.application_name}-${local.ecr_repositories[count.index]}"

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.ecr_kms_key.arn
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "ecr_repository_policy" {
  count      = length(local.ecr_repositories)
  repository = aws_ecr_repository.ecr_repository[count.index].name
  policy     = data.aws_iam_policy_document.ecr_repository_policy.json
}
