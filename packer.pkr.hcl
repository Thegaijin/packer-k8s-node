packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_profile" {
  type = string
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "k8s-ubuntu-node"
  instance_type = "t2.micro"
  region        = "eu-west-2"
  profile       = var.aws_profile
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "k8s-ubuntu-node"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "ansible" {
    playbook_file = "./playbook.yml"
    extra_arguments = [
      "-vv"
    ]
  }
}
