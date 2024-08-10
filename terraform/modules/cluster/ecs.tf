resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name

  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

resource "aws_autoscaling_group" "ecs_cluster_autoscaling_group" {
  name                 = "${var.ecs_cluster_name}-autoscaling-group"
  desired_capacity     = var.asg_desired_size
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  metrics_granularity  = "1Minute"
  termination_policies = ["OldestInstance"]
  vpc_zone_identifier  = var.vpc_public_subnets

  launch_template {
    id = aws_launch_template.ecs_cluster_ec2_instance_launch_template.id
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = "true"
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "ecs_cluster_capacity_provider" {
  name = "${var.ecs_cluster_name}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_cluster_autoscaling_group.arn
  }
}

#######################
### LAUNCH TEMPLATE ###
#######################

resource "aws_launch_template" "ecs_cluster_ec2_instance_launch_template" {
  name          = "${var.ecs_cluster_name}-launch-template"
  image_id      = var.ec2_image_id
  instance_type = var.ec2_instance_type
  user_data     = data.cloudinit_config.template_config.base64_encode

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ecs_cluster_ec2_instance_security_group.id]
    subnet_id                   = tolist(var.vpc_private_subnets)[1]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_cluster_ec2_instance_profile.name
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
  }
}

resource "aws_ecs_service" "backend_ecs_service" {
  name                              = "${var.ecs_cluster_name}-service"
  cluster                           = aws_ecs_cluster.ecs_cluster.id
  desired_count                     = 1
  enable_ecs_managed_tags           = true
  launch_type                       = "FARGATE" # Differents ports mapping only works with EC2 launch type
  propagate_tags                    = "SERVICE"
  task_definition                   = aws_ecs_task_definition.backend_task_definition.arn
  health_check_grace_period_seconds = 60

  load_balancer {
    container_name   = "backend"
    container_port   = 3000
    target_group_arn = aws_lb_target_group.backend_load_balancer_target_group.arn
  }

  #* Work only when network_type is awsvpc and launch_type is FARAGATE
  network_configuration {
    assign_public_ip = false
    subnets          = var.vpc_private_subnets
    security_groups  = [aws_security_group.ecs_cluster_ec2_instance_security_group.id]
  }

  depends_on = [aws_lb_listener.backend_load_balancer_listener, aws_autoscaling_group.ecs_cluster_autoscaling_group]
}
