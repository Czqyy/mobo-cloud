output "alb_dns_name" {
  description = "Public ALB DNS endpoint"
  value       = aws_lb.inference_alb.dns_name
}

output "asg_name" {
  description = "ASG identifier"
  value       = aws_autoscaling_group.fleet.name
}

output "target_group_arn" {
  description = "ARN of Target Group"
  value       = aws_lb_target_group.inference_tg.arn
}