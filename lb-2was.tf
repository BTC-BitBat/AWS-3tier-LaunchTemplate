#NLB 생성
resource "aws_lb" "tier-nlb-was" {
  name               = "tier-nlb-was"
  internal           = true
  load_balancer_type = "network"
  subnets            = [aws_subnet.web-sub-a.id, aws_subnet.web-sub-c.id] #Web Subnet에서 Was를 바라봄

  tags = {
    "Name" = "tier-nlb-was"
  }
}

#Target Group
# Was 의 Tomcat은 8080 Port로 통신
resource "aws_lb_target_group" "tier-n-target-was" {
  name     = "tier-n-target-was"
  port     = 8080
  protocol = "TCP"
  vpc_id   = aws_vpc.tier.id


  tags = {
    "Name" = "tier-n-target-was"
  }
}
#Listener 생성
resource "aws_lb_listener" "tier-n-listner-was" {
  load_balancer_arn = aws_lb.tier-nlb-was.arn
  port              = "8080"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tier-n-target-was.arn
  }
}
output "was_dns_name" {
  value = "aws_lb.tier-nlb-was.dns_name"
}
