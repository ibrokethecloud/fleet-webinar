### Continuous Delivery webinar

Terraform modules used for the continuous delivery webinar.

There are two folders in this repo:

* rancherd: Used to fire up single node rancher install using rancherd.
* import-cluster: Used to fire up a bunch of single node k3s clusters to import and try out the various continuous delivery scenarios.

rancherd setup is driven via the cloud-init.tpl.


For both modules the following terraform variables need to be supplied:

```
variable "vsphere_server" {}
variable "vsphere_user" {}
variable "vsphere_password" {}
variable "ssh_id" {}
variable "vsphere_dc" {}
variable "vsphere_datastore" {}
variable "vsphere_resource_pool" {}
variable "vsphere_network" {}
```