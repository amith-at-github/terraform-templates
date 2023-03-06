
resource "aws_key_pair" "platform" {
  key_name   = var.ssh_key_name
  public_key = file(var.ssh_public_key_path)
}

data "aws_ami" "ubuntu_18" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  name_regex = "^ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-.*"
}

data "aws_ami" "rhel_8" {
  most_recent = true
  owners      = ["309956199498"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  name_regex = "^RHEL-8.*x86_64.*"
}

# locals {
#   ec2_ami_id = var.ec2_ami_type == "rhel" ? data.aws_ami.rhel_8.id : data.aws_ami.ubuntu_18.id
#   # TODO ec2_ami_id = data.aws_ami.amazon_linux_2.id
# }


locals {
  service_instances = flatten([
    for svc_name, svc in var.component : [
      for i in range(0, svc.instance_count) : {
        instance_name = "${svc_name}-${i}"
        instance_type = svc.instance_type
        # data_volume   = svc.data_volume
        subnet_type_public = svc.subnet_type_public
        //subnet_id = "${svc.subnet_type_public ? element(module.aws-network.public_subnet.*.id, i) : element(module.aws-network.private_subnet.*.id, i)}"
        subnet_id = "${svc.subnet_type_public ? element(var.created_aws_public_subnets, i) : element(var.created_aws_private_subnets, i)}"
        vpc_security_group_id= "${svc.subnet_type_public ? aws_security_group.public_bastion_sgs.id : aws_security_group.priv_subnet_sgs.id}"
      }
    ]
  ])
  service_instances_map = {
    for inst in local.service_instances : inst.instance_name => inst
  }
}

resource "aws_instance" "component" {
  # ami = "${local.ec2_ami_id}"
  ami = var.ec2_ami_type == "rhel" ? data.aws_ami.rhel_8.id : data.aws_ami.ubuntu_18.id

  # count = var.ec2_instance_count
  for_each = local.service_instances_map

  instance_type               = each.value.instance_type
  key_name                    = aws_key_pair.platform.key_name
  associate_public_ip_address = each.value.subnet_type_public
  subnet_id                   = each.value.subnet_id
  vpc_security_group_ids= [each.value.vpc_security_group_id,]
  # vpc_security_group_ids = [
  #   "${aws_security_group.public_bastion_sgs.id}",
  #   "${aws_security_group.priv_subnet_sgs.id}"
  # ]
  tags = {
    Name        = "${var.resource_name}-${each.value.instance_name}"
    Owner       = "${var.resource_owner}"
    Email       = "${var.resource_email}"
    Purpose     = "${var.resource_purpose}"
    owner_email = "${var.resource_email}"
  }
  root_block_device {
    volume_size           = 256
    volume_type           = "gp2"
    delete_on_termination = true
  }
  lifecycle {
    ignore_changes = [ami]
  }
}