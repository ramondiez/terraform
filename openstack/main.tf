provider "openstack" {
  user_name = "${var.openstack_user_name}"
  tenant_name = "${var.openstack_tenant_name}"
  password  = "${var.openstack_password}"
  auth_url  = "${var.openstack_auth_url}"
}

resource "openstack_compute_keypair_v2" "terraform" {
  name = "SSH keypair for Terraform instances"  
  public_key = "${file("${var.ssh_key_file}.pub")}"
}

resource "openstack_networking_network_v2" "terraform" {
  name = "terraform"  
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "terraform" {
  name = "terraform"  
  network_id = "${openstack_networking_network_v2.terraform.id}"
  cidr = "192.168.50.0/24"
  ip_version = 4
  enable_dhcp = "true"
  dns_nameservers = ["8.8.8.8","8.8.4.4"]
}

resource "openstack_networking_router_v2" "terraform" {
  name = "terraform"  
  admin_state_up = "true"  
}

resource "openstack_networking_router_interface_v2" "terraform" {  
  router_id = "${openstack_networking_router_v2.terraform.id}"
  subnet_id = "${openstack_networking_subnet_v2.terraform.id}"
}

resource "openstack_compute_secgroup_v2" "terraform" {
  name = "terraform"  
  description = "Security group for the Terraform instances"
  rule {
    from_port = 1
    to_port = 65535
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
  rule {
    from_port = 1
    to_port = 65535
    ip_protocol = "udp"
    cidr = "0.0.0.0/0"
  }
  rule {
    ip_protocol = "icmp"
    from_port = "-1"
    to_port = "-1"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_compute_instance_v2" "terraform" {
  name = "terraform"
  count = "${var.count}"   
  image_name = "${var.image}"
  flavor_name = "${var.flavor}" 
  network {
    uuid = "${openstack_networking_network_v2.terraform.id}"
  } 
}