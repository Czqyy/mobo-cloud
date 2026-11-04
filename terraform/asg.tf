# Worker Launch Template
resource "aws_launch_template" "worker" {
  name_prefix   = "inference-worker-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.worker_ssh_key_name

  vpc_security_group_ids = [aws_security_group.worker_sg.id]
}

# ASG
resource "aws_autoscaling_group" "fleet" {
  name_prefix               = "inference-fleet-"
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  vpc_zone_identifier       = [aws_subnet.cluster_a.id, aws_subnet.cluster_b.id]
  target_group_arns         = [aws_lb_target_group.inference_tg.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.worker.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }
}

# CPU Target Tracking Autoscaling Policy
resource "aws_autoscaling_policy" "cpu_target" {
  name                      = "cpu-target-tracking"
  autoscaling_group_name    = aws_autoscaling_group.fleet.name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 60

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60
  }
}