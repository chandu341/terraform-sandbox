terraform {
  backend "s3" {
    bucket               = "this-bucket-is-for-statefile-storage"
    key                  = "terraform.tfstate"
    region               = "ap-south-1"
    workspace_key_prefix = "env"
    encrypt              = true
    use_lockfile         = true
  }
}