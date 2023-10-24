locals {
  common_tags = {
    Company      = var.company_name
    project_name = "${var.company_name}-${var.project_name}"
    billing_code = var.billing_code
  }

  instance_tags = {
    Name         = "Webserver-1"
    Company      = var.company_name
    project_name = "${var.company_name}-${var.project_name}"
    billing_code = var.billing_code
  }
  s3_bucket_name = "globo-web-app-${random_integer.s3.result}"
  website_contents = {
    website = "./website/index.html"
    logo = "./website/Globo_logo_Vert.png"
  }
}

resource "random_integer" "s3" {
  min = 10000
  max = 99999
}