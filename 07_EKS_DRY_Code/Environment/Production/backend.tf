terraform {
  backend "s3" {
    bucket       = "tfstate-production-mangesh"
    key          = "production/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
