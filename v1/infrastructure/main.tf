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