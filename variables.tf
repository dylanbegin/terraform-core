# Terraform variables for core services.

# Secret variables
variable "pve_host"{
  type      = string
  sensitive = true
}

variable "pve_api_token" {
  type      = string
  sensitive = true
}

variable "pve_ssh_user" {
  type      = string
  sensitive = true
}

variable "pve_ssh_pass" {
  type      = string
  sensitive = true
}

variable "sshuser" {
  type      = string
  sensitive = true
}

variable "sshpass" {
  type      = string
  sensitive = true
}

variable "sshkey" {
  type      = list(string)
  sensitive = true
}

# Apply to all servers
variable "common" {
  default = {
    # VM general settings
    dns         = ["10.10.10.21", "10.10.10.22"]
    domain      = "cryogence.org"
    vmid        = "1001" #ID of template to use
    # VM hardware options
    bios        = "ovmf"
    cpu-type    = "x86-64-v3"
    cpu-sockets = 1
    ballon      = 0
    # VLAN DATA
    ipv4-gw     = "10.10.10.1"
    bridge      = "vmbr1"
    model       = "virtio"
    fw          = false
    # Clone and CI
    clone-node  = "pve1" #template lives on this node
    ci-iface    = "ide0"
    clone-retry = 3
    # Disk
    datastore   = "local-lvm"
    disk-size   = "10"    #Must match template disk size!
    scsihw      = "virtio-scsi-single"
    interface   = "scsi0"
    discard     = "on"
    iothread    = true
    ssd         = true
    # VGA
    vga         = "serial0"
    serial      = "socket"
    # VM options
    onboot      = true
    boot        = ["scsi0"]
    agent       = true
    agent-trim  = true
  }
}

# Apply to all DNS servers
variable "common-dns" {
  default = {
    tag         = ["net", "dns"]
    desc        = "Adguard unbound DNS<br>Alpine Linux"
    dns         = ["10.10.10.1"]
    cores       = 2
    memory      = 2048
  }
}

# Individual DNS server configs.
variable "dns" {
  type = map(any)
  default = {
    dns1 = {
      node      = "pve1"
      id        = "121"
      ipv4-ip   = "10.10.10.21/24"
    }
    dns2 = {
      node      = "pve2"
      id        = "122"
      ipv4-ip   = "10.10.10.22/24"
    }
  }
}

# HC Vault server configs.
variable "vault" {
  type = map(any)
  default = {
    vault = {
      node      = "pve3"
      id        = "135"
      tag       = ["sec"]
      desc      = "Hashicorp Vault<br>Alpine Linux"
      ipv4-ip   = "10.10.10.35/24"
      cores     = 2
      memory    = 2048
    }
  }
}
