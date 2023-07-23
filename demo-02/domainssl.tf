#  SSL certificate from ACM
resource "aws_acm_certificate" "cert" {
  domain_name       = "aspapp.com"
  validation_method = "DNS"

}
resource "aws_route53_zone" "primary" {
  name = "aspapp.com"
}
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.aspapp.com"
  type    = "A"
  ttl     = "300"
  records = [kubernetes_service.aspapp_service.status.0.load_balancer.0.ingress.0.hostname]
}