resource  "aws_iam_role_policy"  "policy" {

 

    
    name =  "myfirstsIAMPolicy"
    role =  aws_iam_role.role.id
    policy =  <<EOF
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
