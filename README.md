# Trabalhando com Terraform e a Amazon Web Services (AWS)

## Visão Geral

Este tutorial tem o objetivo de demonstrar o funcionamento básico da ferramenta **[Terraform](https://www.terraform.io/intro/index.html)** para o provisionamento de um ambiente simples no provedor de cloud computing na **[AWS](https://aws.amazon.com/)**. O tutorial irá te mostrar como realizar o provisionamento dos seguintes itens do ambiente da AWS através de um sistema operacional Windows 10.

 - Amazon EC2 Key Pair
 - Amazon Security Groups
 - Amazon EC2 Instance
 - Amazon S3 Bucket

**Links para Documentação**

 - [Terraform](https://www.terraform.io/docs/index.html)
 - [AWS S3](https://docs.aws.amazon.com/AmazonS3/latest/dev/Introduction.html)
 - [AWS EC2](https://docs.aws.amazon.com/en_us/ec2/?id=docs_gateway)
 - [AWS Security Groups](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-security-groups.html)

## Pré-Requisitos

 - **Windows 10 x64**
 - **CLI da Terraform instalado**, versão igual ou superior à (0.12.28).
 
			 - Download disponível em : https://www.terraform.io/downloads.html
 - **PuTTY**  (Release 0.73 Build platform: 64-bit x86 Windows)
	
			 - Download disponível em: https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html
			 
 - **Conta na console da Amazon Web Services**
 - **Usuário [IAM (Identity Access Management)](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/id_roles.html)** com os seguintes roles associadas a ele:
	 - [AmazonS3FullAccess](https://console.aws.amazon.com/iam/home?region=sa-east-1#policies/arn:aws:iam::aws:policy/AmazonS3FullAccess)
	 - [AmazonEC2FullAccess](https://console.aws.amazon.com/iam/home?region=sa-east-1#policies/arn:aws:iam::aws:policy/AmazonEC2FullAccess)

 
# Introdução

 O [Terraform](https://www.terraform.io/intro/index.html) é uma ferramenta desenvolvida pela empresa [HashiCorp](https://www.hashicorp.com/) tem o objetivo de realizar o deploy, alterar e versionar configurações de ambientes de infraestrutura de uma maneira segura e eficiente.

Os maiores benefícios do uso dessa ferramenta é poder controlar ambientes complexos de infraestrutura através de código, uma vez  que operar manualmente e realizar manutenções em larga escala nestes ambientes é algo muito custoso e suscetível a erros.

## Download e  Configuração do Terraform
**Passo 01: Realizando o download da CLI do Terraform** 

Navegue até o site oficial do Terraform e clique no link da página de [download](https://www.terraform.io/downloads.html).

![Página Oficial de Download do Terraform](https://github.com/guillecosme/Terraform/blob/master/terraform-step-by-step-images/download-terraform-site.PNG)

Feito isto, selecione a opção de download específica para o sistema operacional Windows.

![Opção de Download para Windows](https://github.com/guillecosme/Terraform/blob/master/terraform-step-by-step-images/download-terraform-windowsx64.PNG)

Ao clicar na opção de arquitetura x64 do Windows o download da CLI será iniciado.

Navegue até o diretório padrão de downloads do seu sistema operacional e localize o arquivo recém baixado. Por padrão o arquivo estará disponível na versão **.zip** com a seguinte nomenclatura: 

> **terraform_"Versão da CLI"_windows_amd64.zip**

![Terraform File](https://github.com/guillecosme/Terraform/blob/master/terraform-step-by-step-images/download-terraform-zipFile.PNG)

Crie um novo diretório chamado **Terraform** no seguinte caminho:

> C:\

E nova pasta deverá estar disponível assim:

> C:\Terraform

![Novo Diretório Terraform](https://github.com/guillecosme/Terraform/blob/master/terraform-step-by-step-images/terraform-folder.PNG)

Feito isto extraia o conteúdo da que você recentemente diretamente na no novo diretório criado:

![Extraindo a CLI do Terraform](https://github.com/guillecosme/Terraform/blob/master/terraform-step-by-step-images/terraform-extract-folder-1.PNG)

![Extraindo a CLI do Terraform](https://github.com/guillecosme/Terraform/blob/master/terraform-step-by-step-images/terraform-extract-folder-2.PNG)

![Extraindo a CLI do Terraform](https://github.com/guillecosme/Terraform/blob/master/terraform-step-by-step-images/terraform-extract-folder-3.PNG)

**Passo 02: Configurando o Terraform no Windows 10**

Para configurar a CLI recém baixada abra o Prompt de Comando do Windows 10 e digite o seguinte comando:

    SystemPropertiesAdvanced.exe

Será exibida uma nova tela (**Propriedades Avançadas do Sistema**), ao final da tela clique na opção: **Variáveis de Ambiente**

![Propriedades Avançadas](https://github.com/guillecosme/Terraform/blob/master/terraform-step-by-step-images/SystemPropertiesAdvanced-1.PNG)

Na próxima tela (**Variáveis de Ambiente**) observe o primeiro quadrante exibido e clique sob a variável: **Path** e posteriormente clique no botão editar.

![Propriedades Avançadas](https://github.com/guillecosme/Terraform/blob/master/terraform-step-by-step-images/SystemPropertiesAdvanced-2.PNG)

Uma nova janela será aberta com alguns itens listados clique no botão: **Novo**, localizado ao lado esquerdo superior. Feito isso você poderá incluir uma nova variável de ambiente:

![Propriedades Avançadas](https://github.com/guillecosme/Terraform/blob/master/terraform-step-by-step-images/SystemPropertiesAdvanced-3.PNG)

Na nova linha digite o caminho do novo diretório

> C:\Terraform

![Propriedade Avançadas](https://github.com/guillecosme/Terraform/blob/master/terraform-step-by-step-images/SystemPropertiesAdvanced-4.PNG)

Após concluir estas etapas clique em OK para confirmar as alterações e o Terraform estará configurado e  você poderá realizar o teste do CLI.

**Passo 03: Testando a CLI do Terraform**

Abra o Prompt de Comando do Windows e digite o seguinte comando e pressione ENTER:

    terraform -version

Caso os passos anteriores tenham sido seguidos corretamente o resultado esperado deverá ser algo parecido com isto:

    Terraform v0.12.28


## Iniciando o seu primeiro projeto no Terraform

**Visão Geral**

Nesta etapa iremos efetivamente construir o nosso script Terraform para provisionar um ambiente simples de Infraestrutura na AWS. Neste tutorial utilizei o [Visual Code](https://code.visualstudio.com/) com a [extensão oficial do Terraform](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform) como minha IDE principal, mas fiquem a vontade para utilizar o ambiente de desenvolvimento de sua preferência.

**Passo 01: Criando a pasta do seu primeiro projeto**

Para armazenar o código que será desenvolvido crie uma uma pasta no diretório de sua preferência. Para este tutorial criarei o diretório chamado: **myFirstTerraformEnvironment**

**Passo 02: Iniciando o seu projeto através da IDE**

Conforme mencionado anteriormente irei utilizar o [Visual Code](https://code.visualstudio.com/) para este tutorial. Abra o VSCode  e navegue até as opções abaixo:

    File>Open Folder

Através do Explorer do Windows selecione a nova pasta criada no passo anterior.

No menu da nova pasta criada, dentro do Visual Code, selecione a opção:

    + New File
  
  ![Adicionando um novo Arquivo](https://github.com/guillecosme/Terraform/blob/master/terraform-step-by-step-images/vsCode-NewFile.PNG)

Após adicionar o novo arquivo nomeie o mesmo com a extensão .tf, a extensão oficial de scripts terraform:

![Extensão .tf](https://github.com/guillecosme/Terraform/blob/master/terraform-step-by-step-images/vsCode-NewFile-1.PNG)

Feito isto já será possível construir o script Terraform.

## Construindo o ambiente na AWS
**Passo 01: Inserindo as credencias da AWS no Terraform**

No Visual Code insira os trecho de código abaixo alterando com os dados necessários de sua conta da AWS:

   

    provider  "aws" {
	   region =  "sa-east-1"
	   access_key =  "Insira a suchave de acesso aqui"
	   secret_key =  "Insira a sua senha de Acesso aqui"
	}	   


**Observação:** Nunca compartilhe ou faça upload de trechos de códigos contendo a sua AccessKey e SecretAccessKey da AWS, isto poderá de gerar custos altíssimos se estes dados forem utilizados por terceiros*

Na terminal do próprio Visual Code digite o seguinte comando e pressione ENTER para inicializar a o script Terraform na pasta: **myFirstTerraformEnvironment**

    terraform init

O resultado que esperamos é algo parecido  com isto:

> Terraform has been successfully initialized!
You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.
If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.


**Passo 02: Criando um par de chaves para acesso SSH EC2**

Após criarmos o ambiente na AWS será possível acessar o sistema operacional Linux instalado na instância EC2. 

Para criarmos o chave é possível utilizar o software [**PuTTY Key Generator**](PuTTY%20Key%20Generator), para criar as nossa chave de acesso pública e privada.

Abra o PuTTY Gen e clique na opção:

    Generate
Movimente o mouse de maneira aleatória para gerar a chave pública com os algorítimos de criptografia disponíveis pelo software. Salve a chave pública (.pub) e a chave privada (.ppk) em um diretório seguro (Importante: nunca compartilhe a sua chave privada).

Agora, através do Visual Code, será necessário criar o seguinte script

    # Criando Variáveis para armazenar o path da chave pública de acesso às instâncias EC2
    variable ec2_public_key {
	    default =  "Caminho_da_chave_publica/chave.pub")
    }

O próximo passo é utilizar a chave pública para instanciar a criar um chave de acesso EC2 na console da AWS através do Terraform. Utilize o seguinte trecho de código:

  

     resource  "aws_key_pair"  "myFirstTerraformEnvironment-key" {			 																   key_name =  "myFirstTerraformEnvironment-key"
    	public_key =  file(var.ec2_public_key)
    	tags =  {
    		nome = "myFirstTerraformEnvironment-key"
    		objetivo = "Laboraório-Terraform"
    		}
    	}
  
  **Passo 03: Criando Grupo de Segurança para a instância EC2**

Para que a instância esteja segura iremos criar dois grupos de segurança, um para regras de firewall Inbound e outro para regras Outbound. Liberando os seguintes portocolos TCP:

 - **Inbound**
		 - SSH 	(Porta 22)
		 - HTTP 	(Porta 80)
 - **Outbound**
		 - HTTPS(Porta 443)
		 - HTTP (Porta 80)

Os grupos de segurança são importantes para o controle de tráfego de acessos da sua instância EC2, por padrão ao criar uma nova instância um grupo default será aplicado, este grupo está totalmente aberto à Internet, portanto configure os dois grupos através dos trechos de código abaixo:

**Inbound**
**Grupo: SG-Web-Server-SSH-HTTP-Allow-Inbound**

    resource  "aws_security_group"  "SG-Web-Server-SSH-HTTP-Allow-Inbound" {
		name =  "SG-Web-Server-SSH-HTTP-Allow-Inbound"
        description =  "Grupo de seguranca que libera os 
        rotocolos SSH e HTTP, Inbound"
        ingress {
	        description =  "Libera SSH"
	        protocol =  "tcp"
	        from_port =  "22"
	        to_port =  "22"
        c	idr_blocks =  ["0.0.0.0/0"]
        }
        ingress {
	        description =  "Libera HTTP"
	        protocol =  "tcp"
	        from_port =  "80"
	        to_port =  "80"
	        cidr_blocks =  ["0.0.0.0/0"]
        }
        tags =  {
	        nome = "SG-Web-Server-SSH-HTTP-Allow-Inbound"
	        objetivo = "Laboraório-Terraform"
        }
    }

**Outbound**
**Grupo: SG-Web-Server-HTTPS-HTTP-Allow-Outbound**

    resource  "aws_security_group"  "SG-Web-Server-HTTPS-HTTP-Allow-Outbound" {
	    name =  "SG-Web-Server-HTTPS-HTTP-Allow-Outbound"
	    description =  "Grupo de seguranca que libera os protocolos SSH e HTTP, Outbound"
	    egress {
		    description =  "Libera HTTP"
		    protocol =  "tcp"
		    from_port =  "80"
		    to_port =  "80"
		    cidr_blocks =  ["0.0.0.0/0"]
	    }
	    egress {
		    description =  "Libera HTTPS"
		    protocol =  "tcp"
		    from_port =  "443"
		    to_port =  "443"
		    cidr_blocks =  ["0.0.0.0/0"]
	    }
	    tags =  {
		    nome = "SG-Web-Server-HTTPS-HTTP-Allow-Outbound"
		    objetivo = "Laboraório-Terraform"
	    }
    }

**Passo 03: Criando um Bucket S3 e realizando Upload de arquivos**

No ambiente a ser provisionando iremos criar um Web-Server que irá ser o host de uma página web estática, esta página web será armazenada primeiramente num Bucket S3. 

Para criar o bucket e realizar o upload dos arquivos da página web, utilize o seguinte trecho de código:

    resource  "aws_s3_bucket"  "myfirstterraformenvironment" {
	    bucket =  "myfirstterraformenvironment"
	    acl =  "private"
	    versioning {
		    enabled =  false
	    }
	    tags =  {
		    nome = "myfirstterraformenvironment"
		    objetivo = "Laboraório-Terraform"
		}
	}
