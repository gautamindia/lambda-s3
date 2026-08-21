terraform {
  
  backend "s3" {
    bucket = "statefile-lambda-596057427845-ap-south-1-an"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    use_lockfile = true
    encrypt = true
  }
}