resource "aws_lb" "backend_load_balancer" {
  name                       = "${var.ecs_cluster_name_abbr}-alb"
  enable_deletion_protection = true
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = var.vpc_public_subnets
  security_groups            = [aws_security_group.alb_security_group.id]
}

resource "aws_lb_target_group" "backend_load_balancer_target_group" {
  name        = "${var.ecs_cluster_name_abbr}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/healthcheck"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "backend_load_balancer_listener" {
  load_balancer_arn = aws_lb.backend_load_balancer.arn
  port              = 80
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06" # When using HTTPS

  default_action {
    target_group_arn = aws_lb_target_group.backend_load_balancer_target_group.arn
    type             = "forward"
  }

  lifecycle {
    replace_triggered_by = [aws_lb_target_group.backend_load_balancer_target_group.id]
  }
}
