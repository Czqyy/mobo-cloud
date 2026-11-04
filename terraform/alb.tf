# Internet-Facing ALB
resource "aws_lb" "inference_alb" {
  name               = "inference-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.cluster_a.id, aws_subnet.cluster_b.id]

  enable_cross_zone_load_balancing = true
  idle_timeout                     = 60
}

# Target Group
resource "aws_lb_target_group" "inference_tg" {
  name        = "inference-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.cluster_vpc.id
  target_type = "instance"

  load_balancing_cross_zone_enabled = "use_load_balancer_configuration"

  health_check {
    enabled             = true
    path                = "/health"
    port                = "8000"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# HTTP Listener on Port 80 with Catch-All Forwarding
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.inference_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.inference_tg.arn
  }
}