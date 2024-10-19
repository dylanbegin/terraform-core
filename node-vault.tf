# Terraform plan for Hashicorp Vault on Proxmox.
# ---

# Vault server
resource "proxmox_virtual_environment_vm" "vault" {
  for_each = var.vault

  # VM general settings
  node_name      = each.value.node
  vm_id          = each.value.id
  name           = each.key
  tags           = each.value.tag
  description    = each.value.desc

  # VM clone template
  clone {
    node_name    = var.common.clone-node
    vm_id        = var.common.vmid
    datastore_id = var.common.datastore
    retries      = var.common.clone-retry
  }

  # VM cloud-init configuration
  initialization {
    datastore_id = var.common.datastore
    interface    = var.common.ci-iface
    dns {
      servers    = var.common.dns
      domain     = var.common.domain
    }
    ip_config {
      ipv4 {
        address  = each.value.ipv4-ip
        gateway  = var.common.ipv4-gw
      }
    }
    user_account {
      username   = var.sshuser
      password   = var.sshpass
      keys       = var.sshkey
    }
  }

  # VM hardware options
  bios           = var.common.bios
  cpu {
    type         = var.common.cpu-type
    sockets      = var.common.cpu-sockets
    cores        = each.value.cores
  }
  memory {
    dedicated    = each.value.memory
    shared       = var.common.ballon
  }
  # VLAN DATA
  network_device {
    bridge       = var.common.bridge
    model        = var.common.model
    firewall     = var.common.fw
  }
  scsi_hardware  = var.common.scsihw
  disk {
    datastore_id = var.common.datastore
    interface    = var.common.interface
    size         = var.common.disk-size
    discard      = var.common.discard
    iothread     = var.common.iothread
    ssd          = var.common.ssd
  }
  vga {
    type         = var.common.vga
  }
  serial_device {
    device       = var.common.serial
  }
  # VM options
  on_boot        = var.common.onboot
  boot_order     = var.common.boot
  agent {
    enabled      = var.common.agent
    trim         = var.common.agent-trim
  }
}
