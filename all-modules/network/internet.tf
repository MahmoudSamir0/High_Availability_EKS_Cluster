resource "aws_internet_gateway" "it" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = var.internet-get
  }
}
resource "aws_route_table" "myroute" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.it.id
  }
  tags = {
    Name = var.rout-public
  }
}


resource "aws_route_table_association" "myrout-a" {
  subnet_id      = aws_subnet.mysub_az1[0].id
  route_table_id = aws_route_table.myroute.id
}

resource "aws_route_table_association" "myrout-b" {
  subnet_id      = aws_subnet.mysub_az2[0].id
  route_table_id = aws_route_table.myroute.id
}