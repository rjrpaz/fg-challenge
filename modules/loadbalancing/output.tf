output "lb_endpoint" {
  value = aws_lb.alb.dns_name
}

output "lb_target_group_arn" {
  value = aws_lb_target_group.target_group.arn
}

