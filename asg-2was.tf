#Was ASG 생성
resource "aws_autoscaling_group" "was_autoscaling_group" {
  name                = "was-Auto_scaling"
  vpc_zone_identifier = [aws_subnet.was-sub-a.id, aws_subnet.was-sub-c.id]

  launch_template {
    id      = aws_launch_template.tier_was_launch_template.id
    version = "$Latest"
  }
  force_delete = true

  desired_capacity = 2
  min_size         = 2
  max_size         = 6

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Name"
    value               = "Was-ASG"
    propagate_at_launch = true
  }

  depends_on = [
    aws_nat_gateway.tier-nat, aws_autoscaling_group.was_autoscaling_group
  ]
}

#Was ASG attachment
resource "aws_autoscaling_attachment" "was_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.was_autoscaling_group.id
  lb_target_group_arn    = aws_lb_target_group.tier-n-target-was.arn
}
