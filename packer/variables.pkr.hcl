## Image & artifact details ##

variable "iso_url" {
  type    = string
  default = "https://releases.ubuntu.com/noble/ubuntu-24.04.2-live-server-amd64.iso"
  # default = "file:///path/to/ubuntu-24.04.2-live-server-amd64.iso"
}
variable "iso_checksum" {
  type    = string
  default = "sha256:d6dab0c3a657988501b4bd76f1297c053df710e06e0c3aece60dead24f270b4d"
}

## Builder and resource details ##

variable "cpus" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 4096
}

variable "disk_size" {
  type    = string
  default = "5G"
}

## User details ##

variable "hostname" {
  type    = string
  default = "comfycloud"
}
variable "username" {
  type    = string
  default = "comfy"
}
variable "hashed_password" {
  type = string
  # use `openssl passwd -6 [password]`
}
variable "ssh_keys" {
  type    = list(string)
  default = []
}

## Tailscale ##

variable "tailscale_api_key" {
  type      = string
  sensitive = true
}