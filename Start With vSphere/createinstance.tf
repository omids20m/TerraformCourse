#https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs
provider "vsphere" {
  user           = "administrator@vsphere.local"
  password       = ""
  vsphere_server = "172.16.18.25"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "DevOps-DC"
}

data "vsphere_datastore" "datastore" {
  name          = "DS02-SSD-HV01"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "TFPool"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}


#data "vsphere_host" "hs" {
#  name = "host1"
#  datacenter_id = data.vsphere_datacenter.dc.id
#}

#data "vsphere_ovf_vm_template" "ovf" {
#  name             = "testOVF"
#  resource_pool_id = data.vsphere_resource_pool.pool.id
#  datastore_id     = data.vsphere_datastore.datastore.id

#  vsphere_ovf_vm_template = "BuildServer"

#  host_system_id   = data.vsphere_host.hs.id
  #remote_ovf_url   = "https://download3.vmware.com/software/vmw-tools/nested-esxi/Nested_ESXi7.0_Appliance_Template_v1.ova"

  #ovf_network_map = {
  #  "Network 1": data.vsphere_network.net.id
  #}
#}

data "vsphere_virtual_machine" "template" {
  name = "BS2"
  datacenter_id = data.vsphere_datacenter.dc.id


  #resource_pool_id = data.vsphere_resource_pool.pool.id
  #datastore_id     = data.vsphere_datastore.datastore.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-test"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 4098
  guest_id = "windows9Server64Guest"

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      windows_options {
        computer_name = "Build20"
        workgroup = "WORKGROUP"
        admin_password = "123456"
      }
      network_interface {
        ipv4_address = "172.16.18.20"
        ipv4_netmask = 24
      }

      ipv4_gateway = "172.16.18.1"
    }
  }

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = 90
  }
}
