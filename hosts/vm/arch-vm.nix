{ pkgs, userConfig, ... }:

let
  archVmHcl = pkgs.writeText "arch-vm.pkr.hcl" ''
    packer {
      required_plugins {
        qemu = {
          version = ">= 1.0.0"
          source  = "github.com/hashicorp/qemu"
        }
      }
    }

    source "qemu" "arch" {
      iso_url           = "https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso"
      iso_checksum      = "file:https://geo.mirror.pkgbuild.com/iso/latest/sha256sums.txt"
      output_directory  = "output-arch-vm"
      shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
      disk_size         = "${toString userConfig.vm.diskSize}"
      format            = "qcow2"
      accelerator       = "kvm"
      ssh_username      = "packer"
      ssh_password      = "packer"
      ssh_timeout       = "20m"
      vm_name           = "arch-vm"
      memory            = "${toString userConfig.vm.memorySize}"
      cpus              = "${toString userConfig.vm.cores}"
      headless          = false
      boot_wait         = "8s"
      boot_command      = [
        "<enter><wait15><wait15>",
        "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/arch-preseed.sh<enter><wait5>",
        "/usr/bin/bash arch-preseed.sh<enter>"
      ]
      http_directory    = "${toString ./.}/scripts/preseed"
      ssh_handshake_attempts = "20"
    }

    build {
      sources = ["source.qemu.arch"]

      provisioner "shell" {
        inline = [
          "echo 'packer' | sudo -S pacman -Syu --noconfirm",
          "echo 'packer' | sudo -S pacman -S --noconfirm base-devel git vim"
        ]
      }


      provisioner "shell" {
        script = "${toString ./.}/scripts/install-nix.sh"
      }

      provisioner "shell" {
        script = "${toString ./.}/scripts/gen-config.sh"
      }

      provisioner "shell" {
        script = "${toString ./.}/scripts/install/arch-setup.sh"
      }

      provisioner "shell" {
        
      }

    }
  '';
in
{
  build-vm = pkgs.writeShellScriptBin "run-arch-vm" ''
    ${pkgs.packer}/bin/packer init ${archVmHcl}
    ${pkgs.packer}/bin/packer build ${archVmHcl}
  '';
  run-vm = pkgs.writeShellScriptBin "run-arch-vm" ''
    VM_IMAGE="output-arch-vm/arch-vm"
    if [ ! -f "$VM_IMAGE" ]; then
      echo "VM image not found. Please run build-vm first."
      exit 1
    fi

    ${pkgs.qemu}/bin/qemu-system-x86_64 \
      -m ${toString userConfig.vm.memorySize} \
      -smp ${toString userConfig.vm.cores} \
      -drive file=$VM_IMAGE,format=qcow2 \
      -net nic -net user,hostfwd=tcp::2222-:22 \
      -display gtk \
      -enable-kvm
  '';
}
