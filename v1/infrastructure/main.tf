terraform {
  backend "s3" {
    # Bucket name
    bucket         = "checkmeoutdemoterraformstate"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-1"
    # DynamoDB table name
    dynamodb_table = "checkmeoutdemoterraformstatelock"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucketname
  acl    = "public-read"
    
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
  versioning {
    enabled = true
  }

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucketname}/*"
            ]
        }
    ]
}
EOF

  website {
    index_document = "index.html"
    error_document = "error.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
}

resource "aws_acm_certificate" "certificate" {
  // We want a wildcard cert so we can host subdomains later.
  domain_name       = "*.${var.domain_name}"
  validation_method = "EMAIL"

  // We also want the cert to be valid for the root domain even though we'll be
  // redirecting to the www. domain immediately.
  subject_alternative_names = ["${var.domain_name}"]
}