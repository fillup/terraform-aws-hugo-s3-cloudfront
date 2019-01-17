// Provider vars for authentication
variable "aliases" {
  description = "List of hostnames to serve site on. E.g. with and without www"
  type        = "list"
}

variable "aws_region" {
  type    = "string"
  default = "us-east-1"
}

variable "bucket_name" {
  description = "Name of bucket to be created in S3. Must be globally unique."
  type        = "string"
}

variable "cert_domain" {
  description = "Domain name on ACM certificate"
  type        = "string"
}

variable "cf_default_ttl" {
  description = "CloudFront default TTL for cachine"
  type        = "string"
  default     = "86400"
}

variable "cf_min_ttl" {
  description = "CloudFront minimum TTL for caching"
  type        = "string"
  default     = "0"
}

variable "cf_max_ttl" {
  description = "CloudFront maximum TTL for caching"
  type        = "string"
  default     = "31536000"
}

variable "cf_price_class" {
  description = "CloudFront price class"
  type        = "string"
  default     = "PriceClass_All"
}

variable "origin_path" {
  description = "Path in S3 bucket for hosted files, without slashes"
  type        = "string"
  default     = "public"
}

variable "routing_rules" {
  description = "A json array containing routing rules describing redirect behavior and when redirects are applied"
  type        = "string"

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
  type        = "string"
  default     = "hugo-s3-origin"
}

variable "viewer_protocol_policy" {
  description = "One of allow-all, https-only, or redirect-to-https"
  type        = "string"
  default     = "redirect-to-https"
}
