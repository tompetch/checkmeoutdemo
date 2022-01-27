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
resource "aws_s3_bucket_object" "index_html_upload" {

  bucket = aws_s3_bucket.website_bucket.id
  key    = "index.html"
  acl    = "public-read"
  content = "./v1/application/index.html"
  server_side_encryption  = "AES256"

}

resource "aws_s3_bucket_object" "error_html_upload" {

  bucket = aws_s3_bucket.website_bucket.id
  key    = "error.html"
  acl    = "public-read"
  content = "./v1/application/error.html"
  server_side_encryption  = "AES256"

}