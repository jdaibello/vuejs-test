##############
### LOCALS ###
##############

locals {
  ecs_cluster_role_managed_policies = [
    "arn:aws:iam::aws:policy/service-role/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  ]
}

################
### POLICIES ###
################

data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type       = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

#############
### ROLES ###
#############

resource "aws_iam_role" "ecs_cluster_ec2_instance_role" {
  name               = "${var.application_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
  path               = "/"
}

############################
### POLICIES ATTACHMENTS ###
############################

resource "aws_iam_role_policy_attachment" "ecs_cluster_ec2_instance_role_attachment" {
  count      = length(local.ecs_cluster_role_managed_policies)
  role       = aws_iam_role.ecs_cluster_ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

#########################
### INSTANCE PROFILES ###
#########################

resource "aws_iam_instance_profile" "ecs_cluster_ec2_instance_profile" {
  name  = "${var.ecs_cluster_name}-ec2-instance-profile"
  role  = aws_iam_role.ecs_cluster_ec2_instance_role.name
  path  = "/"
}

data "cloudinit_config" "template_config" {
  gzip          = false
  base64_encode = true

  part {
    content = templatefile("${path.module}/userdata/userdata.sh", {
      ecs_cluster_name = var.ecs_cluster_name
    })

    content_type = "text/x-shellscript"
  }
}
