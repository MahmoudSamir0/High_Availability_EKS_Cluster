resource "aws_subnet" "mysub_az1" {
  vpc_id                  = aws_vpc.myvpc.id
  count                   = length(var.subnet_id_az1)
  cidr_block              = var.subnet_id_az1[count.index]
  map_public_ip_on_launch = var.true-and-false[count.index]
  availability_zone       = "us-east-1a"
  tags = {
    Name = var.subnet_name_az1[count.index]
  }
}

resource "aws_subnet" "mysub_az2" {
  vpc_id                  = aws_vpc.myvpc.id
  count                   = length(var.subnet_id_az2)
  cidr_block              = var.subnet_id_az2[count.index]
  map_public_ip_on_launch = var.true-and-false[count.index]
  availability_zone       = "us-east-1b"
  tags = {
    Name = var.subnet_name_az2[count.index]
  }
}

