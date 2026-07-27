terraform {
  backend "s3" {
    bucket       = "tfstate-devlopment-mangesh"
    key          = "devlopement/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}