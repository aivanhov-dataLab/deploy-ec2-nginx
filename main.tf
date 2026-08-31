provider "aws" {
  region     = "eu-west-3"
  secret_key = var.cle_secret
  access_key = var.cle_access
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "myapp-subnet" {
  source = "./modules/subnet"

  subnet_cidr_block = var.subnet_cidr_block
  available_zone    = var.available_zone
  env_prefix        = var.env_prefix
  vpc_id            = aws_vpc.myapp-vpc.id
  /*route_table_id = var.route_table_id */

}

module "myapp-webserver" {
  source = "./modules/webserver"

  ami            = var.ami
  instance_type  = var.instance_type
  available_zone = var.available_zone
  vpc_id         = aws_vpc.myapp-vpc.id
  env_prefix     = var.env_prefix
  my_ip          = var.my_ip
  my_ssh_key     = var.my_ssh_key
  subnet_id      = module.myapp-subnet.subnet.id
  user_data = file("${path.root}/entry-script.sh")


}





