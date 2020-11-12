provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}


variable "vsphere_server" {}
variable "vsphere_user" {}
variable "vsphere_password" {}
variable "ssh_id" {}
variable "vsphere_dc" {}
variable "vsphere_datastore" {}
variable "vsphere_resource_pool" {}
variable "vsphere_network" {}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_dc
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "ubuntu-bionic-cloudimg-amd64"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "k3s" {
  name             = "fleet-k3s-${count.index+1}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  count = 1
  num_cpus  = 4
  memory    = 8196
  guest_id  = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  cdrom {
    client_device = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

  }

  vapp {
    properties = {
      user-data = "${base64encode(templatefile("${path.module}/cloud-init.tpl", {node_name = "fleet-k3s-${count.index+1}", ssh_key = file(var.ssh_id) }))}"
      hostname = "fleet-k3s-${count.index+1}"
    }
  }

  disk {
    label            = "disk0"
    size             = 20
    unit_number      = 0
    thin_provisioned = "true"
  }


}

