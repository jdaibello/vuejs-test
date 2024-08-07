#* AWS message: AWS CodeCommit is no longer available to new customers.
#*              Existing customers of AWS CodeCommit can continue to use the service as normal.

#! Error when applying this resource:
#! CreateRepository request is not allowed because there is no existing repository in this AWS account or AWS Organization

# resource "aws_codecommit_repository" "codecommit_repository" {
#   repository_name = "${var.aws_username}-frontend"
#   description     = "CodeCommit repository for ${var.aws_username}-frontend"

#   depends_on = [aws_iam_role.github_actions_role]  # Exemplo de dependência
# }
