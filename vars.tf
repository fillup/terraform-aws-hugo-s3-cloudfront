// Provider vars for authentication
variable "aliases" {
  description = "List of hostnames to serve site on. E.g. with and without www"
  type        = list(string)
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "bucket_name" {
  description = "Name of bucket to be created in S3. Must be globally unique."
  type        = string
}

variable "cert_domain" {
  description = "Domain name on ACM certificate"
  type        = string
}

variable "cf_default_ttl" {
  description = "CloudFront default TTL for cachine"
  type        = string
  default     = "86400"
}

variable "cf_min_ttl" {
  description = "CloudFront minimum TTL for caching"
  type        = string
  default     = "0"
}

variable "cf_max_ttl" {
  description = "CloudFront maximum TTL for caching"
  type        = string
  default     = "31536000"
}

variable "cf_price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_All"
}

variable "cors_allowed_headers" {
  description = "List of headers allowed in CORS"
  type        = list(string)
  default     = []
}

variable "cors_allowed_methods" {
  description = "List of methods allowed in CORS"
  type        = list(string)
  default     = ["GET"]
}

variable "cors_allowed_origins" {
  description = "List of origins allowed to make CORS requests"
  type        = list(string)
  default     = ["https://s3.amazonaws.com"]
}

variable "cors_expose_headers" {
  description = "List of headers to expose in CORS response"
  type        = list(string)
  default     = []
}

variable "cors_max_age_seconds" {
  description = "Specifies time in seconds that browser can cache the response for a preflight request"
  type        = string
  default     = 3000
}

variable "custom_error_response" {
  description = "Optionally a list of custom error response configurations for CloudFront distribution"
  type = set(object({
    error_code         = number
    response_code      = number
    response_page_path = string
  }))
  default = []
}

variable "default_root_object" {
  description = "CloudFront distribution default_root_object"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Error page document in S3 bucket"
  type        = string
  default     = "404.html"
}

variable "index_document" {
  description = "Index page document in S3 bucket"
  type        = string
  default     = "index.html"
}

variable "minimum_viewer_tls_version" {
  description = "Minimum TLS version for viewers connecting to CloudFront"
  type        = string
  default     = "TLSv1.2_2019"
}

variable "origin_path" {
  description = "Path in S3 bucket for hosted files, with leading slash"
  type        = string
  default     = "/public"
}

variable "origin_ssl_protocols" {
  type        = list(string)
  description = "List of Origin SSL policies for Cloudfront distribution. See https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html#DownloadDistValues-security-policy for options"
  default     = ["TLSv1.2"]
}

variable "routing_rules" {
  description = "A json array containing routing rules describing redirect behavior and when redirects are applied"
  type        = string

  default = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "/"
    },
    "Redirect": {
        "ReplaceKeyWith": "index.html"
    }
}]
EOF

}

variable "s3_origin_id" {
  description = "Origin ID used in CloudFront"
  type        = string
  default     = "hugo-s3-origin"
}

variable "viewer_protocol_policy" {
  description = "One of allow-all, https-only, or redirect-to-https"
  type        = string
  default     = "redirect-to-https"
}

variable "deployment_user_arn" {
  description = "ARN for user who is able to put objects into S3 bucket"
  type        = string
}
