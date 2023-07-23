module "key" {
  source       = "../all-modules/keypair"
  encrypt-kind = "RSA"
  encrypt-bits = 4096
}