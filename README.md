# Terraform module for hosting Hugo sites on S3 and CloudFront

This module creates an S3 bucket with proper configuration to support Hugo's friendly urls. 
It also creates a CloudFront distribution with special S3 origin configuration to support S3 
redirects. S3 static websites can be accessed via three different hostname formats, but only one
supports S3 redirects. This module helps keep setup consistent for multiple Hugo sites. 

## Required Inputs 

 - `aliases` - A list of hostname aliases for CloudFront to listen on
 - `bucket_name` - Name of bucket to use, must be globally unique
 - `cert_domain` - Domain name on existing Amazon Certificate Manager certificate to use with CloudFront. :warning: Only certificates in `us-east-1` will work for CloudFront (your arn should begin with `arn:aws:acm:us-east-1:xxxxxxxxxxx:certificate/...`)
 - `deployment_user_arn` - ARN to a user to be given permission to put objects into the bucket

## Optional Inputs

 - `aws_region` - The AWS region to create the S3 bucket in. Default: `us-east-1`
 - `cf_default_ttl` - Default CloudFront caching TTL. Default: `86400`
 - `cf_min_ttl` - Minimum CloudFront caching TTL. Default: `0`
 - `cf_max_ttl` - Maximum CloudFront caching TTL. Default: `31536000`
 - `cf_price_class` - The CloudFront pricing class to use. Default: `PriceClass_All`
 - `custom_error_response` - A list of objects to provide custom error responses from CloudFront. 
    See [Using Custom Error Responses from CloudFront](#using-custom-error-responses-from-cloudfront) for details. 
 - `default_root_object` - Default root object for CloudFlare to request when not otherwise specified. Default: `index.html`
 - `error_document` - The file that should be served for errors. Default: `404.html`
 - `index_document` - The default file to be served. Default: `index.html`
 - `minimum_viewer_tls_version` - Minimum TLS version for viewers connecting to CloudFront. Default: `TLSv1.2_2019`
 - `origin_path` - Path to document root in S3 bucket without slashes. Default: `public`
 - `origin_ssl_protocols` - List of SSL protocols to enable on Cloudfront distribution. Default: `TLSv1.2` 
 - `routing_rules` - A json array containing routing rules describing redirect behavior and when redirects are applied. Default routes `/` to `index.html` 
 - `viewer_protocol_policy` - One of allow-all, https-only, or redirect-to-https. Default: `redirect-to-https`
 - `cors_allowed_headers` - List of headers allowed in CORS. Default: `[]`
 - `cors_allowed_methods` - List of methods allowed in CORS. Default: `["GET"]`
 - `cors_allowed_origins` - List of origins allowed to make CORS requests. Default: `["https://s3.amazonaws.com"]`
 - `cors_expose_headers`  - List of headers to expose in CORS response. Default: `[]`
 - `cors_max_age_seconds` - Specifies time in seconds that browser can cache the response for a preflight request. Default: `3000`
 
## Usage Example

```hcl
module "hugosite" {
  source              = "github.com/fillup/terraform-hugo-s3-cloudfront"
  aliases             = ["www.domain.com", "domain.com"]
  bucket_name         = "www.domain.com"
  cert_domain         = "*.domain.com"
  deployment_user_arn = "arn:aws:iam::111122223333:person"
}
```

## Using Custom Error Responses from CloudFront
Cloudfront allows you to override error responses if desired. This is useful when hosting Single Page Apps on S3 
and want to leverage the default error document to route all requests to your index, but prevent S3 from returning
a 404 error to the browser. Here is an example of replacing 404 errors with 200 OK responses. 

```hcl
module "hugosite" {
  source              = "github.com/fillup/terraform-hugo-s3-cloudfront"
  aliases             = ["www.domain.com", "domain.com"]
  bucket_name         = "www.domain.com"
  cert_domain         = "*.domain.com"
  deployment_user_arn = "arn:aws:iam::111122223333:person"
  default_root_object = null
  error_document      = "index.html"
  custom_error_response = [
      {
        error_code         = 404
        response_code      = 200
        response_page_path = "/index.html"
      },
    ]
}
```

## License - MIT
MIT License

Copyright (c) 2020 Phillip Shipley

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
