
resource "libvirt_volume" "nxos7" {
  name = "nxos7"
  source = "backing_images/titanium-final.7.3.0.D1.1.qcow2"
}

resource "libvirt_volume" "nxos7-1" {
  name = "nxos7-1"
  source = "${libvirt_volume.nxos7.id}"

  provisioner "local-exec" {
    command = "guestfish add ${self.id} : run : mount /dev/sda4 / : upload $(pwd)/configs/${self.name}.txt /nxos_config.txt : cat /nxos_config.txt : quit"
  }
}

resource "libvirt_domain" "nxos7-1" {
  name = "nxos7-1"
  memory = "4096"
  vcpu = 4

  network_interface {
    network_name = "vm_network"
  }
  network_interface {
    network_name = "default"
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

