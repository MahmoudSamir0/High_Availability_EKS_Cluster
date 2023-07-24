module "IAM" {
  source = "../all-modules/IAM"
}
resource "aws_iam_openid_connect_provider" "default" {
  url = module.ekscluster.cluster_oidc_issuer_url

  client_id_list = [
  "sts.amazonaws.com"]

  thumbprint_list = [aws_acm_certificate.cert.arn]
}

