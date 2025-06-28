# Comfy-Cloud
Tools for building, deploying, and destroying a GPU VM with pre-installed libraries, models, and frontends. Keeps cloud costs low by storing everything in the VM image instead of taking time to download/install dependencies.

Primarily built for MI300X GPU droplets on DigitalOcean.

⚠️ This project is still a WIP ⚠️

What's preinstalled:
- AMD ROCm 6.3
- PyTorch
- ComfyUI
    - ComfyUI Manager


## Prerequisites
- Ensure that Packer, Terraform, and QEMU are installed.
- Create a copy of `variables.pkrvars.hcl` and rename it to `variables.auto.pkrvars.hcl`

todo: write the rest of this

## Building the VM Image

## Deploying the VM with Terraform

## Destroying the VM with Terraform


## Create a VM manually using `virt-install`
This is great for testing/debugging outside of a packer build. This method will use the autoinstall file for an unattended install. Skip steps 2, 3, and set `extra-args` to only `console=tty50` in step 4 for no autoinstall.

1. Mount your iso to the filesystem
```sh
mkdir /mnt/youriso
sudo mount -o loop /path/to/your.iso /mnt/yourisoMounted
```
2. Create `user-data` and `meta-data`. You can use [cloud-init.yaml](packer/scripts/cloud-init.yaml) for as a base for `user-data` and keep `meta-data` empty.
```sh
cp ./packer/scripts/cloud-init.yaml ./packer/http/user-data
touch ./packer/http/meta-data
```

3. Serve `user-data` over http.
```sh
cd ./packer/http
npx http-server --listen 0.0.0.0 # Or use any other http server you like
```
4. Run `virt-install`:
```sh
sudo virt-install \
--name manualvm \
--vcpus 2 \
--memory 4096 \
--disk /path/to/vm/disk.qcow2,size=5,format=qcow2  \
--disk /path/to/your.iso,device=cdrom \
--location /mnt/yourisoMounted \
--install kernel=/mnt/yourisoMounted/casper/vmlinuz,initrd=/mnt/yourisoMounted/casper/initrd \
--os-variant ubuntu24.04 \
--virt-type kvm \
--graphics none \
--console pty,target_type=serial \
--extra-args 'autoinstall ds=nocloud;s=http://ww.xx.yy.zz:8080/ console=ttyS0'
```

- To find what IP to supply in `extra-args`, use `ip a` and check under `virbr0`
- To find the IP of the VM, use `sudo virsh net-list` and `sudo virsh net-dhcp-leases NET_NAME`

5. Clean up your VM
```sh
sudo virsh destroy manualvm
sudo virsh undefine manualvm #using --remove-all-storage with this will delete your iso here!
sudo rm /path/to/vm/disk
```

## FAQ
### Why use QEMU to build this if you're using the cloud anyway?
Great question!

### Why didn't you answer that?
Another great question! Keep it up!

### :/
:)