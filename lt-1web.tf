#Launch Template 생성
resource "aws_launch_template" "tier_web_launch_template" {
  name          = "Web-launch-template"
  description   = "WEB-LaunchTemplate"
  image_id      = "ami-0eddbd81024d3fbdd"
  instance_type = "t2.micro"
  key_name      = "tier-web-key"

  network_interfaces {
    associate_public_ip_address = false
  }
  vpc_security_group_ids = []

  tags = {
    "Name" = "Web_launchTemplate"
  }
}
