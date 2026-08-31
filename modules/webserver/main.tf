
resource "aws_instance" "myapp-instance" {
  ami           = var.ami
  instance_type = var.instance_type

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.myapp-SG.id]
  availability_zone      = var.available_zone

  associate_public_ip_address = true
  key_name                    = "server-key"
 
  //user_data = file("${path.root}/entry-script.sh")
  user_data = var.user_data

  tags = {
    Name : "${var.env_prefix}-server"
  }

}

resource "aws_security_group" "myapp-SG" {
  name   = "myapp-SG"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name : "${var.env_prefix}-sg"
  }
}
/*
data "aws_ami" "lates-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
    filter {

    }
}*/

resource "aws_key_pair" "ssh-key" {
  key_name   = "server-key"
  public_key = var.my_ssh_key
}