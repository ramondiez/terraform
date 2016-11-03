variable "image" {
  default = "TestVM"
}

variable "flavor" {
  default = "m1.micro"
}

variable "openstack_user_name" {
    description = "The username for the Tenant."
    default  = "terraform"
}

variable "openstack_tenant_name" {
    description = "The name of the Tenant."
    default  = "terraform"
}

variable "openstack_password" {
    description = "The password for the Tenant."
    default  = "terraform"
}

variable "openstack_auth_url" {
    description = "The endpoint url to connect to OpenStack."
    default  = "http://172.16.0.3:5000/v2.0"
}

variable "ssh_key_file" {
    default = "~/.ssh/id_rsa"
}

variable "count" {
  default = 2
}