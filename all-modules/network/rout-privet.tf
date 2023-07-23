resource "aws_route_table" "privett" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }

  tags = {
    Name = var.route-nat
  }
}

resource "aws_route_table_association" "privett-a" {
  subnet_id      = aws_subnet.mysub_az1[1].id
  route_table_id = aws_route_table.privett.id
}
