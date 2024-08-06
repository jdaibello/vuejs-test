#* Create AWS Builder ID for CodeCatalyst before creating a CodeCatalyst space

#! It also doesn't works:
#! module.code.aws_codecatalyst_project.test: Creating...
#! ╷
#! │ Error: Request cancelled
#! │
#! │ The plugin.(*GRPCProvider).ApplyResourceChange request was cancelled.

# resource "aws_codecatalyst_project" "test" {
#   space_name   = "${var.aws_username}-frontend"
#   display_name = "${var.aws_username}-frontend"
#   description  = "${var.aws_username}-frontend CodeCatalyst Project created using Terraform"
# }
