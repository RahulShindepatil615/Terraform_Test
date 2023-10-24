# create s3 bucket
resource "aws_s3_bucket" "web_bucket" {
  bucket = local.s3_bucket_name
force_destroy = true
  tags = local.common_tags
}


# create s3 bucket policy
resource "aws_s3_bucket_policy" "web_bucket_policy" {
  bucket = aws_s3_bucket.web_bucket.id
  //policy = data.aws_iam_policy_document.allow_s3_bucket_access.json
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_elb_service_account.root.arn}"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}"
    }
  ]
}
    POLICY
}

# create s3 object
resource "aws_s3_object" "website_contents" {
  for_each = local.website_contents
  bucket = aws_s3_bucket.web_bucket.bucket
  key    = each.value
  source = "${path.root}/${each.value}"

  tags = local.common_tags
}
