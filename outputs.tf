output "aws_alb_public_dns" {
  value       = "http://${aws_lb.webserver-lb-tf.dns_name}"
  description = "Public DNS for the ALB"
}