# Terraform module for hosting Hugo sites on S3 and CloudFront

This module creates an S3 bucket with proper configuration to support Hugo's friendly urls. 
It also creates a CloudFront distribution with special S3 origin configuration to support S3 
redirects. S3 static websites can be accessed via three different hostname formats, but only one
supports S3 redirects. This module helps keep setup consistent for multiple Hugo sites. 

## Required Inputs 

 - `aliases` - A list of hostname aliases for CloudFront to listen on
 - `bucket_name` - Name of bucket to use, must be globally unique
 - `cert_domain` - Domain name on existing Amazon Certificate Manager certificate to use with CloudFront

## Optional Inputs

 - `aws_region` - The AWS region to create the S3 bucket in. Default: `us-east-1`
 - `cf_default_ttl` - Default CloudFront caching TTL. Default: `86400`
 - `cf_min_ttl` - Minimum CloudFront caching TTL. Default: `0`
 - `cf_max_ttl` - Maximum CloudFront caching TTL. Default: `31536000`
 - `cf_price_class` - The CloudFront pricing class to use. Default: `PriceClass_All`
 - `origin_path` - Path to document root in S3 bucket without slashes. Default: `public`
 
## Usage Example

```hcl
module "hugosite" {
  source      = "github.com/fillup/terraform-hugo-s3-cloudfront"
  aliases     = ["www.domain.com", "domain.com"]
  bucket_name = "www.domain.com"
  cert_domain = "*.domain.com"
}
```

## License - MIT
MIT License

Copyright (c) 2018 Phillip Shipley

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