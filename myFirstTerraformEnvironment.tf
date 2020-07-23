# Selecionando o provide <AWS> e passando o usuário e senha do IAM

provider "aws" {
  region     = "sa-east-1"
  access_key = "Insira a sua Chave"
  secret_key = "Insira a sua Chave"
}

# Criando Variáveis para armazenar o path da chave pública de acesso às instâncias EC2
variable ec2_public_key {
  default = ("Path_da_sua_Chave_Publica")
}

resource "aws_key_pair" "myFirstTerraformEnvironment-key" {
    key_name = "myFirstTerraformEnvironment-key"
    public_key = file(var.ec2_public_key)
    tags = {
        name = "myFirstTerraformEnvironment-key"
        objetivo = "Laboratório-Terraform"
    }
}

# Criação de grupos  de segurança para as instâncias EC2

resource "aws_security_group" "SG-Web-Server-SSH-HTTP-Allow-Inbound" {
    name = "SG-Web-Server-SSH-HTTP-Allow-Inbound"
    description = "Grupo de seguranca que libera os protocolos SSH e HTTP, Inbound"

    ingress {
        description = "Libera SSH"
        protocol = "tcp"
        from_port = "22"
        to_port = "22"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Libera HTTP"
        protocol = "tcp"
        from_port = "80"
        to_port = "80"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        name = "SG-Web-Server-SSH-HTTP-Allow-Inbound"
        objetivo = "Laboratório-Terraform"
    }
}

resource "aws_security_group" "SG-Web-Server-HTTPS-HTTP-Allow-Outbound" {
    name = "SG-Web-Server-HTTPS-HTTP-Allow-Outbound"
    description = "Grupo de seguranca que libera os protocolos SSH e HTTP, Outbound"
    egress {
        description = "Libera HTTP"
        protocol = "tcp"
        from_port = "80"
        to_port = "80"
        cidr_blocks = ["0.0.0.0/0"]
    }
     egress {
        description = "Libera HTTPS"
        protocol = "tcp"
        from_port = "443"
        to_port = "443"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        name = "SG-Web-Server-HTTPS-HTTP-Allow-Outbound"
        objetivo = "Laboratório-Terraform"
    }
}

# Criação do Bucket S3
resource "aws_s3_bucket" "bucket" {
    bucket = "myfirstterraformenvironment"
    acl = "private"
    force_destroy = true
    versioning {
        enabled = false
    }    
    tags = {
        name = "myfirstterraformenvironment"
        objetivo = "Laboratório-Terraform"
    }    
}

#Realizando o Upload de arquivos página index
resource "aws_s3_bucket_object" "object-01" {
    bucket = aws_s3_bucket.bucket.bucket
    key = "index.html"
    source = "Path da Página index.html"
    tags = {
        name = "myfirsts3object"
        objetivo = "Laboratório-Terraform"
    }    
}

#Realizando o Upload de arquivos pasta .zip com as despendências html
resource "aws_s3_bucket_object" "object-02" {
    bucket = aws_s3_bucket.bucket.bucket
    key = "assets.zip"
    source = "Path da pasta assets.zip"
    tags = {
        name = "myfirsts3object"
        objetivo = "Laboratório-Terraform"
    }    
}

#Criando um IAM role para que a instância EC2 possa ler o S3
resource "aws_iam_role" "role" {     
  name = "myfirstsIAMRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
        name = "myfirstsIAMRole"
        objetivo = "Laboratório-Terraform"
    }  
}

#Criando um Instance Profile para o noss IAM Role e EC2
resource "aws_iam_instance_profile" "profile" {
  name = "myfirstsInstanceProfile"
  role = aws_iam_role.role.name  
}

#Criando a policy IAM 
resource "aws_iam_role_policy" "policy" {    
  name = "myfirstsIAMPolicy"
  role = aws_iam_role.role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

#Criando aa instância E2
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


#Desenvolvido por @GuilhermeCosme
#TerraformScript
#Julho-2020





