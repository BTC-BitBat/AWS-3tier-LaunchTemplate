#Web ASG 생성
resource "aws_autoscaling_group" "web_autoscaling_group" {
  name                = "Web-Auto_scaling"
  vpc_zone_identifier = [aws_subnet.web-sub-a.id, aws_subnet.web-sub-c.id]

  launch_template {
    id      = aws_launch_template.tier_web_launch_template.id
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
    value               = "WEB-ASG"
    propagate_at_launch = true
  }

  depends_on = [
    aws_nat_gateway.tier-nat, aws_autoscaling_group.was_autoscaling_group
  ]
}

#Web ASG attachment
resource "aws_autoscaling_attachment" "web_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web_autoscaling_group.id
  lb_target_group_arn    = aws_lb_target_group.tier-a-target-web.arn
}
