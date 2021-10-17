resource "aws_lb" "alb" {
  name = "loadbalancer"
  subnets = var.public_subnets
  security_groups = [var.public_sg]
  idle_timeout = 400
  tags = {
    Name  = var.name
    Owner = var.owner
  }
}

resource "aws_lb_target_group" "target_group" {
  name = "lb-tg"
  port = var.tg_port # 80
  protocol = var.tg_protocol # HTTP
  vpc_id = var.vpc_id
  lifecycle {
    ignore_changes = [name]
    create_before_destroy = true
  }
  health_check {
    healthy_threshold = var.lb_healthy_threshold # 2
    unhealthy_threshold = var.lb_unhealthy_threshold # 2
    timeout = var.lb_timeout # 3
    interval = var.lb_interval # 30
  }
  tags = {
    Name  = var.name
    Owner = var.owner
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = var.listener_port # 80
  protocol = var.listener_protocol # "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
  tags = {
    Name  = var.name
    Owner = var.owner
  }
}

