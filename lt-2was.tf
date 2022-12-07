#Launch Template 생성
resource "aws_launch_template" "tier_was_launch_template" {
  name          = "was-launch-template"
  description   = "WAS-LaunchTemplate"
  image_id      = "ami-0eddbd81024d3fbdd"
  instance_type = "t2.micro"
  key_name      = "tier-was-key"

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [aws_security_group.tier-sg-pri-was.id]
  }
  
  update_default_version = true

  tags = {
    "Name" = "WAS_launchTemplate"
  }
}
