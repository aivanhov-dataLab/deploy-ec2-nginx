☁️ Cloud Foundation with Terraform






Building AWS infrastructure with Terraform using Infrastructure as Code and reusable modules.

This repository contains my hands-on journey into AWS Cloud, Terraform, Infrastructure as Code (IaC), and DevOps practices.

The project starts with a simple AWS infrastructure and progressively evolves toward a more scalable, secure, modular, and production-oriented cloud architecture.

🎯 Project Objectives

The main goals of this project are to:

Learn and practice Terraform fundamentals
Provision AWS infrastructure using Infrastructure as Code
Understand AWS networking fundamentals
Build reusable Terraform modules
Understand Terraform variables and outputs
Understand Terraform resource dependencies
Deploy and configure EC2 instances
Practice Git and GitHub workflows
Progressively move toward production-ready cloud architecture
🏗️ Current Architecture

The current version provisions a basic AWS environment containing:

                         AWS
                          │
                          ▼
                   ┌──────────────┐
                   │      VPC     │
                   │  10.0.0.0/16 │
                   └───────┬──────┘
                           │
                           ▼
                   ┌──────────────┐
                   │    Subnet    │
                   │  10.0.1.0/24 │
                   └───────┬──────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
              ▼            ▼            ▼
          Route Table   Security     EC2 Instance
              │          Group            │
              │                           │
              ▼                           │
       Internet Gateway                   │
              │                           │
              └────────── Internet ───────┘

AWS Resources
Resource	Purpose
VPC	Provides an isolated virtual network
Subnet	Hosts the EC2 instance
Internet Gateway	Provides internet connectivity
Route Table	Routes traffic to the Internet Gateway
Route Table Association	Associates the subnet with the route table
Security Group	Controls network traffic
Key Pair	Provides SSH authentication
EC2 Instance	Runs the application/server
🧩 Terraform Module

The networking components related to the subnet are encapsulated in a reusable Terraform module.

modules/
└── subnet/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf


The subnet module is responsible for:

Subnet Module
│
├── AWS Subnet
├── Internet Gateway
├── Route Table
└── Route Table Association


The root module calls the subnet module:

module "myapp-subnet" {
  source = "./modules/subnet"

  subnet_cidr_block = var.subnet_cidr_block
  available_zone    = var.available_zone
  env_prefix        = var.env_prefix
  vpc_id            = aws_vpc.myapp-vpc.id
}


The module exposes resource information through outputs:

output "subnet_id" {
  value = aws_subnet.myapp-subnet-1.id
}

output "route_table_id" {
  value = aws_route_table.myapp-route-table.id
}


The root module can then consume these outputs:

subnet_id = module.myapp-subnet.subnet_id


This demonstrates the Terraform module communication pattern:

              Child Module
                   │
                   │ outputs
                   ▼
              Root Module
                   │
                   │ module.myapp-subnet.subnet_id
                   ▼
              EC2 Instance

📁 Project Structure
.
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── entry-script.sh
├── .gitignore
│
└── modules/
    └── subnet/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf

Root Module

The root module manages:

AWS VPC
Security Group
EC2 instance
SSH Key Pair
Subnet module
Subnet Module

The subnet module manages:

AWS Subnet
Internet Gateway
Route Table
Route Table Association
🛠️ Technologies
Cloud
AWS
Amazon VPC
Amazon EC2
AWS Internet Gateway
AWS Route Tables
AWS Security Groups
Infrastructure as Code
Terraform
Terraform Modules
Terraform Variables
Terraform Outputs
Development Tools
Git
GitHub
AWS CLI
Linux / Windows
🚀 Getting Started
Prerequisites

Make sure the following tools are installed:

Terraform
Git
AWS CLI

Verify Terraform:

terraform version


Verify AWS CLI:

aws --version

🔐 AWS Authentication

Configure your AWS credentials locally using the AWS CLI:

aws configure


Verify the AWS identity:

aws sts get-caller-identity


⚠️ Security: Never commit AWS access keys, secret keys, private keys, or sensitive credentials to GitHub.

For production environments, IAM roles and other secure credential mechanisms should be preferred over static credentials.

⚙️ Configuration

Create a local terraform.tfvars file containing your environment-specific configuration.

Example:

vpc_cidr_block    = "10.0.0.0/16"
subnet_cidr_block = "10.0.1.0/24"

available_zone = "eu-west-3a"

env_prefix = "myapp"

instance_type = "t2.micro"

ami = "YOUR_AMI_ID"

my_ip = "YOUR_PUBLIC_IP/32"

my_ssh_key = "YOUR_PUBLIC_SSH_KEY"


The exact variables depend on the project's variables.tf.

🔄 Terraform Workflow
1. Initialize Terraform
terraform init

2. Format the configuration
terraform fmt

3. Validate the configuration
terraform validate

4. Review the execution plan
terraform plan

5. Deploy the infrastructure
terraform apply

6. Destroy the infrastructure

When the infrastructure is no longer needed:

terraform destroy

🧠 Terraform Concepts Practiced
Variables

Infrastructure configuration is externalized using Terraform variables.

variable "vpc_cidr_block" {
  type = string
}


This makes the infrastructure easier to reuse and customize.

Resources

AWS resources are defined declaratively:

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
}

Modules

Related resources are grouped into reusable modules.

Root Module
│
└── subnet module
    ├── subnet
    ├── internet gateway
    ├── route table
    └── route association

Outputs

Outputs allow child modules to expose values to their parent module.

output "subnet_id" {
  value = aws_subnet.myapp-subnet-1.id
}


The root module consumes the output:

module.myapp-subnet.subnet_id

Dependencies

Terraform automatically creates a dependency graph based on resource references.

For example:

vpc_id = aws_vpc.myapp-vpc.id


means that the VPC must exist before the dependent resource can be created.

The resulting dependency flow is approximately:

VPC
 │
 ├── Subnet
 │
 └── Internet Gateway
         │
         ▼
     Route Table
         │
         ▼
 Route Table Association
         │
         ▼
    EC2 Instance

🔒 Security Considerations

This project is primarily intended for learning purposes.

Before using a similar architecture in production, consider:

Using IAM roles instead of static AWS credentials
Restricting SSH access to trusted IP addresses
Avoiding 0.0.0.0/0 where it is not necessary
Using private subnets for internal workloads
Managing secrets securely
Protecting Terraform state
Using remote Terraform state
Implementing least-privilege IAM policies
Enabling monitoring and logging
🚧 Roadmap

The project will evolve progressively toward a more production-oriented AWS architecture.

Phase 1 — Terraform Fundamentals
 Create AWS VPC
 Create subnet
 Create Internet Gateway
 Create route table
 Associate route table with subnet
 Create Security Group
 Deploy EC2 instance
 Use Terraform variables
 Use Terraform outputs
 Create Terraform module
Phase 2 — AWS Networking
 Multiple Availability Zones
 Public subnets
 Private subnets
 NAT Gateway
 Network architecture improvements
 Network ACLs
Phase 3 — High Availability
 Application Load Balancer
 Auto Scaling Group
 Multiple EC2 instances
 Multi-AZ deployment
Phase 4 — Terraform Production Practices
 Remote Terraform state
 S3 backend
 State locking
 Environment separation
 Reusable modules
 CI/CD pipeline
 Automated Terraform validation
 Automated Terraform plan
 GitHub Actions
Phase 5 — Monitoring & Security
 CloudWatch
 CloudWatch Logs
 IAM roles
 CloudTrail
 AWS Systems Manager
 Secrets management
 Security hardening
📈 Project Evolution

The long-term goal is to evolve this project from a simple Terraform exercise into a more realistic cloud infrastructure.

                    CURRENT
                       │
                       ▼
              ┌─────────────────┐
              │       VPC       │
              │    Subnet       │
              │    EC2          │
              └────────┬────────┘
                       │
                       ▼
                  NETWORKING
                       │
                       ▼
              ┌─────────────────┐
              │ Public Subnets  │
              │ Private Subnets │
              │ NAT Gateway     │
              └────────┬────────┘
                       │
                       ▼
                 HIGH AVAILABILITY
                       │
                       ▼
              ┌─────────────────┐
              │      ALB        │
              │ Auto Scaling    │
              │    Multi-AZ     │
              └────────┬────────┘
                       │
                       ▼
                  PRODUCTION
                       │
                       ▼
              ┌─────────────────┐
              │ Remote State    │
              │ CI/CD           │
              │ Monitoring      │
              │ Security        │
              └─────────────────┘

💡 What I Am Learning

This project is focused on learning by building and troubleshooting real infrastructure.

Through this project, I am developing practical skills in:

AWS Cloud
Cloud networking
Infrastructure as Code
Terraform
Terraform modules
Resource dependencies
Infrastructure automation
Git and GitHub
DevOps practices
Cloud security fundamentals

The objective is not simply to create AWS resources, but to understand how cloud infrastructure is designed, automated, maintained, and progressively improved.

🌱 Project Status

🚧 Learning / Development

The current implementation focuses on the fundamentals of:

AWS Networking + Terraform + Modules + EC2

The architecture will be progressively improved as new AWS, Terraform, DevOps, security, and automation concepts are introduced.

📚 Next Steps

The next major objective is to move from a simple public subnet architecture toward a more realistic AWS environment:

                    Internet
                       │
                       ▼
                 Internet Gateway
                       │
              ┌────────┴────────┐
              │     VPC         │
              │                 │
              │ Public Subnets  │
              │       │         │
              │      ALB        │
              │       │         │
              │ Private Subnets │
              │       │         │
              │      EC2        │
              │       │         │
              │   NAT Gateway   │
              └─────────────────┘


This will allow the project to demonstrate additional concepts such as high availability, private networking, scalability, security, and automation.

👨‍💻 Author

This repository is part of my hands-on journey into:

AWS Cloud · Terraform · DevOps · Infrastructure as Code

The project is continuously evolving as I learn and implement new cloud and DevOps concepts.

⭐ Feedback

Suggestions, improvements, and best-practice recommendations are welcome.

If you find something that could be improved, feel free to open an issue or submit a pull request.

📄 License

This project is intended for educational and learning purposes.