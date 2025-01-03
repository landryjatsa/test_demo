terraform {
  backend "s3" {
    bucket         = "terraform-state-eks-cluster"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}