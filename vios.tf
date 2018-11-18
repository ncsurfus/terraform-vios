# instance the provider
provider "libvirt" {
  uri = "qemu:///system"
}

# Create a network for our VMs
resource "libvirt_network" "vm_network" {
   name = "vm_network"
   addresses = ["10.0.1.0/24"]
}

# Create a master volume to conserve space
resource "libvirt_volume" "vios-l3" {
  name = "vios-l3"
  source = "backing_images/vios-adventerprisek9-m.SPA.156-2.T.qcow2"
}

resource "libvirt_volume" "vios-l2" {
  name = "vios-l2"
  source = "backing_images/vios_l2-adventerprisek9-m.SSA.152-4.0.55.E.qcow2"
}

# Create a volume based on the master
resource "libvirt_volume" "rtr-1" {
  name = "rtr-1"
  source = "${libvirt_volume.vios-l3.id}"

  provisioner "local-exec" {
    command = "guestfish add ${self.id} : run : mount /dev/sda1 / : upload $(pwd)/configs/${self.name}.txt /ios_config.txt : cat /ios_config.txt : quit"
  }
}

resource "libvirt_volume" "sw-1" {
  name = "sw-1"
  source = "${libvirt_volume.vios-l2.id}"

  provisioner "local-exec" {
    command = "guestfish add ${self.id} : run : mount /dev/sda1 / : upload $(pwd)/configs/${self.name}.txt /ios_config.txt : cat /ios_config.txt : quit"
  }
}

# Create the machine
resource "libvirt_domain" "rtr-1" {
  name = "rtr-1"
  memory = "512"
  vcpu = 1

  network_interface {
    network_name = "vm_network"
  }
  network_interface {
    network_name = "vm_network"
  }
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  disk {
       volume_id = "${libvirt_volume.rtr-1.id}"
  }
  xml {
    xslt = "${file("nicmodel.xsl")}"
  }
}

resource "libvirt_domain" "sw-1" {
  name = "sw-1"
  memory = "512"
  vcpu = 1

  network_interface {
    network_name = "vm_network"
  }
  network_interface {
    network_name = "vm_network"
  }
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  disk {
       volume_id = "${libvirt_volume.sw-1.id}"
  }
  xml {
    xslt = "${file("nicmodel.xsl")}"
  }
}
