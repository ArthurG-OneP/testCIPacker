packer {
  required_plugins {
    amazon = {
      version = ">= 1.3"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "aws-example" {
  ami_name         = var.ami_name
  source_ami       = var.ami_source_id
  instance_type    = "t2.micro"
  region           = var.region
  ssh_username     = "admin"
}

build {
  sources = ["source.amazon-ebs.aws-example"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y apache2",
      "echo '<h1> Hello lab </h1>' | sudo tee /var/www/html/index.html",
      "sudo systemctl enable apache2",
      "sudo systemctl start apache2"
    ]
  }
}

variable "region" {
  type    = string
  default = "eu-west-1"  # ireland
}

variable "ami_source_id" {
  type    = string
  default = "ami-0715d656023fe21b4"  # debian 12 ireland
}

variable "ami_name" {
  type    = string
  default = "arthur-ami-name"
}