data "aws_vpc" "Data-source-vpc" {
  id = "vpc-05a7b5a46ee47c7dc"
}

resource "aws_internet_gateway" "Data-source-internet-gateway" {
  vpc_id = data.aws_vpc.Data-source-vpc.id

  tags = {
    Name = "Data-source-internet-gateway"
  }
}
