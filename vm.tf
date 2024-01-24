resource "aws_vpc" "my_vpc" { cidr_block = "10.0.0.0/16" } 
resource "aws_subnet" "my_subnet" {
	vpc_id = aws_vpc.my_vpc.id 
	cidr_block = "10.0.0.0/24" 
	}

resource "aws_security_group" "my_sg" {
  name        = "my-security-group"
  vpc_id = aws_vpc.my_vpc.id
  description = "Allow inbound SSH and HTTP traffic"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0a346c29399cd4934"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  tags={
    Name = "my-ec2-instance"
  }
}
