/*
 * Create S3 bucket with appropriate permissions
 */
data "template_file" "bucket_policy" {
  template = file("${path.module}/bucket-policy.json")

  vars = {
    bucket_name         = var.bucket_name
    deployment_user_arn = var.deployment_user_arn
  }
}

resource "aws_s3_bucket" "hugo" {
  bucket        = var.bucket_name
  acl           = "public-read"
  policy        = data.template_file.bucket_policy.rendered
  force_destroy = true

  website {
    index_document = var.index_document
    error_document = "${var.origin_path}/${var.error_document}"

    // Routing rule is needed to support hugo friendly urls
    routing_rules = var.routing_rules
  }

  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
    expose_headers  = var.cors_expose_headers
    max_age_seconds = var.cors_max_age_seconds
  }
}

// Get ACM cert for use with CloudFront
data "aws_acm_certificate" "cert" {
  domain = var.cert_domain
}

/*
 * Create CloudFront distribution for SSL support but caching disabled, leave that to Cloudflare
 */
resource "aws_cloudfront_distribution" "hugo" {
  count      = 1
  depends_on = [aws_s3_bucket.hugo]

  origin {
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = var.origin_ssl_protocols
    }

    // Important to use this format of origin domain name, it is the only format that
    // supports S3 redirects with CloudFront
    domain_name = "${var.bucket_name}.s3-website-${var.aws_region}.amazonaws.com"

    origin_id   = var.s3_origin_id
    origin_path = var.origin_path
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_response
    content {
      error_code         = custom_error_response.value.error_code
      response_code      = custom_error_response.value.response_code
      response_page_path = custom_error_response.value.response_page_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.default_root_object

  aliases = var.aliases

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy

    // Using CloudFront defaults, tune to liking
    min_ttl     = var.cf_min_ttl
    default_ttl = var.cf_default_ttl
    max_ttl     = var.cf_max_ttl
  }

  price_class = var.cf_price_class

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
