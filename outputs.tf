output "ec2_public_ip" {
  value       = aws_instance.myapp-instance.public_ip
  description = "Public Ip of the ec2"
}
/*
output "aws_ami-id" {
  value       = data.aws.latest-amazon-linux-image.id
  
}
*/