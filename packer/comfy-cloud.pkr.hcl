packer {
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "vmbuilder" {
  # Base image & artifact details
  iso_url          = var.iso_url
  iso_checksum     = var.iso_checksum
  disk_size        = var.disk_size
  format           = "qcow2"
  output_directory = "output"

  # Build config and resources
  boot_command = [
    "e<wait><down><down><down>",
    "<end><left><left><left><left>",
    "autoinstall ds=nocloud\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }} PACKER_SSH_KEY={{ .SSHPublicKey | urlquery}}",
    "<F10>"
  ]
  http_directory   = "./http"
  headless         = true
  shutdown_command = "echo 'Packer' | sudo -S shutdown -P now"
  ssh_username     = "root"
  ssh_timeout      = "30m"
  disk_interface   = "virtio"
  boot_wait        = "10s"

  # qemu builder config
  cpus        = var.cpus
  memory      = var.memory
  accelerator = "kvm"
  vm_name     = var.hostname
  net_device  = "virtio-net"
}

source "file" "userdata" {
  content = templatefile("scripts/cloud-init.yaml", {
    hostname        = var.hostname
    username        = var.username
    hashed_password = var.hashed_password
    ssh_keys        = var.ssh_keys
  })
  target = "http/user-data"
}

source "file" "metadata" {
  content = "\n"
  target  = "http/meta-data"
}

build {
  sources = ["source.file.userdata", "source.file.metadata", "source.qemu.vmbuilder"]

  provisioner "shell" {
    scripts = ["scripts/installer.sh"]
  }
}

# todo:
# would be cool to have local artifact repo for iso and model storage
# use digital ocean post-processor to upload the qcow2 image