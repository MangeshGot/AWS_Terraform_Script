terraform {
  backend "s3" {
    bucket       = "tfstate-staging-mangesh"
    key          = "staging/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
