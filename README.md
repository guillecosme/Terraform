resource "aws_instance" "myfirstterraform-WebServer" {
   instance_type = "t2.micro"
   ami = "ami-081a078e835a9f751"
   key_name = "myFirstTerraformEnvironment-key"
   security_groups = ["SG-Web-Server-HTTPS-HTTP-Allow-Outbound","SG-Web-Server-SSH-HTTP-Allow-Inbound"]
   iam_instance_profile = aws_iam_instance_profile.profile.name
   user_data = <<EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo service httpd start
    sudo groupadd www
    sudo usermod -a -G www ec2-user
    sudo chgrp -R www /var/www
    sudo chmod 2775 /var/www
    find /var/www -type d -exec sudo chmod 2775 {} +
    find /var/www -type f -exec sudo chmod 0664 {} +
    aws s3 sync s3://myfirstterraformenvironment/ /var/www/html/
    cd /var/www/html  
    unzip assets.zip          
   EOF
   tags = {
        name = "myfirstterraform-WebServer"
        objetivo = "Laboratório-Terraform"
    } 
}
