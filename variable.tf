variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
  default     = ""
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "resource_group_name" {
  type    = string
  default = "rg-banking-terraform"
}

variable "vnet_name" {
  type    = string
  default = "vnet-banking"
}

variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnet_prefixes" {
  type = map(string)
  default = {
    dmz      = "10.0.1.0/24"
    web      = "10.0.2.0/24"
    business = "10.0.3.0/24"
    data     = "10.0.4.0/24"
    mgmt     = "10.0.5.0/24"
  }
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for Linux VMs"
  default     = "~/.ssh/id_rsa.pub"
}
