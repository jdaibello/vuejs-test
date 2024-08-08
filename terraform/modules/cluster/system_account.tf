# ECS Cluster

##############
### LOCALS ###
##############

locals {
  ecs_cluster_role_managed_policies = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
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

# Task Definition

################
### POLICIES ###
################

data "aws_iam_policy_document" "ecs_tasks_asssume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "allow_ssm_policy" {
  name = "${var.application_name}-allow-ssm-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ssm:GetParameters",
      "Resource": "${var.ssm_parameter_common_arn}/*"
    }
  ]
}
EOF
}

#############
### ROLES ###
#############

resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.application_name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_asssume_role_policy.json
  path               = "/"
}

##########################
### POLICY ATTACHMENTS ###
##########################

resource "aws_iam_role_policy_attachment" "ecs_task_role_managed_policies_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  count      = length(local.ecs_cluster_role_managed_policies)
  policy_arn = local.ecs_cluster_role_managed_policies[count.index]
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_allow_ssm_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn =aws_iam_policy.allow_ssm_policy.arn
}
