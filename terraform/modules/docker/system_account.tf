##############
### LOCALS ###
##############

locals {
  system_account_role_managed_policies = [
    # "arn:aws:iam::aws:policy/AdministratorAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
  ]
}

################
### POLICIES ###
################

data "aws_iam_policy_document" "system_account_assume_role_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = ["arn:aws:sts::${data.aws_caller_identity.current.account_id}:user/${var.aws_username}"]
    }
  }
}

#############
### ROLES ###
#############

resource "aws_iam_role" "system_account_role" {
  name = "${var.application_name}-system-account-role"
  assume_role_policy = data.aws_iam_policy_document.system_account_assume_role_policy.json
  path = "/"
}

#############################
### POLICIES ATTACHEMENTS ###
#############################

resource "aws_iam_role_policy_attachment" "system_account_assume_role_policy_attachement" {
  role = aws_iam_role.system_account_role.name
  count = length(local.system_account_role_managed_policies)
  policy_arn = local.system_account_role_managed_policies[count.index]
  depends_on = [aws_iam_role.system_account_role]
}
