module "s3-bucket" {
  source      = "../all-modules/s3/"
  bucket-name = "terraform-update-and-run-state"
  status      = "Enabled"
}