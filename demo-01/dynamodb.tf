module "dynamo" {
  source        = "../all-modules/dynamodb"
  dynamodb-name = "terraform-update-and-run-state"
}