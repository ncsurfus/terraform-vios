
resource "libvirt_volume" "nxos9" {
  name = "nxos9"
  source = "backing_images/nxosv-final.7.0.3.I7.2.qcow2"
}

resource "libvirt_volume" "nxos9-1" {
  name = "nxos9-1"
  source = "${libvirt_volume.nxos9.id}"

  provisioner "local-exec" {
    command = "guestfish add ${self.id} : run : mount /dev/sda4 / : upload $(pwd)/configs/${self.name}.txt /nxos_config.txt : cat /nxos_config.txt : quit"
  }
}

resource "libvirt_domain" "nxos9-1" {
  name = "nxos9-1"
  memory = "8192"
  vcpu = 2

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
       volume_id = "${libvirt_volume.nxos9-1.id}"
  }
}

