#Launch Template 생성
resource "aws_launch_template" "tier_web_launch_template" {
  name          = "Web-launch-template"
  description   = "WEB-LaunchTemplate"
  image_id      = "ami-0eddbd81024d3fbdd"
  instance_type = "t2.micro"
  key_name      = "tier-web-key"

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [aws_security_group.tier-sg-pri-web.id]
  }
  
  update_default_version = true

  user_data = base64encode(templatefile("${path.module}/userdata/web.tpl",
  {
    apache_server_name="apache"
    web_alb_dns=aws_lb.tier-alb-web.dns_name
    web_alb_port="8080"
    web_app=""
    was_app=""
  }))

  tags = {
    "Name" = "Web_launchTemplate"
  }
}
