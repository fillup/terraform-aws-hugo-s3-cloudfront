module "simple" {
  source = "../"

  aliases             = ["www"]
  bucket_name         = "bucket"
  cert_domain         = "example.com"
  deployment_user_arn = "arn:aws:iam::1234567890:user/deploy"
}

module "full" {
  source = "../"

  aliases                    = ["www"]
  aws_region                 = "us-east-1"
  bucket_name                = "bucket"
  cert_domain                = "example.com"
  cf_default_ttl             = "86400"
  cf_min_ttl                 = "0"
  cf_max_ttl                 = "31536000"
  cf_price_class             = "PriceClass_All"
  cors_allowed_headers       = []
  cors_allowed_methods       = ["GET"]
  cors_allowed_origins       = ["https://s3.amazonaws.com"]
  cors_expose_headers        = []
  cors_max_age_seconds       = "3000"
  custom_error_response      = []
  default_root_object        = "index.html"
  error_document             = "404.html"
  index_document             = "index.html"
  minimum_viewer_tls_version = "TLSv1.2_2019"
  origin_path                = "/public"
  origin_ssl_protocols       = ["TLSv1.2"]
  routing_rules              = "[]"
  s3_origin_id               = "hugo-s3-origin"
  viewer_protocol_policy     = "redirect-to-https"
  deployment_user_arn        = "arn:aws:iam::1234567890:user/deploy"
}
