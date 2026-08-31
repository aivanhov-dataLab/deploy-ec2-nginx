
#!/bin/bash

yum update -y

yum install -y docker

systemctl enable docker
systemctl start docker

usermod -aG docker ec2-user

docker pull nginx

docker run -d --name nginx -p 8080:80 nginx