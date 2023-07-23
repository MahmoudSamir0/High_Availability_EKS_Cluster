resource "aws_nat_gateway" "gw" {
  subnet_id     = aws_subnet.mysub_az1[0].id
  allocation_id = aws_eip.elastic_id.id

  tags = {
    "name" = var.nat-name
  }
}

