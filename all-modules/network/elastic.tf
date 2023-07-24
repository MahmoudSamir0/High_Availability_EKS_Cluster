resource "aws_eip" "elastic_id" {
  vpc = true
  tags = {
    Name = "master_eip"
  }
}
