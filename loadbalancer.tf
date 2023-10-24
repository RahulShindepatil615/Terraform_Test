data "aws_elb_service_account" "root" {}

resource "aws_lb" "webserver-lb-tf" {
  name               = "webserver-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.subnets[*].id
  enable_deletion_protection = false
  access_logs {
    bucket  = aws_s3_bucket.web_bucket.id
    prefix  = "alb-logs"
    enabled = true

  }
  tags = local.common_tags
}

#  Create target group
resource "aws_lb_target_group" "webapp-target-group" {
  name     = "webapp-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

# create target group attachment
resource "aws_lb_target_group_attachment" "webapp-target-group-attachments" {
  count = var.instance_count
  target_group_arn = aws_lb_target_group.webapp-target-group.arn
  target_id        = aws_instance.ngnix[count.index].id
  port             = 80
}

# create listener

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.webserver-lb-tf.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp-target-group.arn
  }
}

