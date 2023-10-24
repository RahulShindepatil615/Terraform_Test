# create EC2 instance
# get image details
data "aws_ami" "ami_details" {
  filter {
    name   = "name"
    values = [var.ami_name]
  }
  owners = ["amazon"]

}
# create instance I
resource "aws_instance" "ngnix" {
  count = var.instance_count
  ami                         = data.aws_ami.ami_details.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnets[count.index].id
  vpc_security_group_ids      = [aws_security_group.WebServer_Security_Group.id]
  iam_instance_profile        = aws_iam_instance_profile.ngnix_profile.name
  associate_public_ip_address = true
  depends_on                  = [aws_iam_role_policy.allow_s3_all]
  tags                        = {
    Name = "WebServer-${count.index}"
  }

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><head><title>Taco Team Server 1</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
EOF
}


# iam role
resource "aws_iam_role" "allow_nginx_s3" {
  name = "allow_nginx_s3"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = local.common_tags
}

# instance profile

resource "aws_iam_instance_profile" "ngnix_profile" {
  name = "ngnix_profile"
  role = aws_iam_role.allow_nginx_s3.name
}

resource "aws_iam_role_policy" "allow_s3_all" {
  name = "allow_s3_all"
  role = aws_iam_role.allow_nginx_s3.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
                "arn:aws:s3:::${local.s3_bucket_name}",
                "arn:aws:s3:::${local.s3_bucket_name}/*"
            ]
    }
  ]
}
EOF


}


