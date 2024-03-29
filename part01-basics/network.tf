# Azure network security group
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.resource_pattern}-nsg"
  location            = "${data.azurerm_resource_group.dev.location}"
  resource_group_name = "${data.azurerm_resource_group.dev.name}"

  security_rule {
    name                        = "${var.resource_pattern}-nsr-http-inbound"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "80"
    destination_port_range      = "80"
    source_address_prefix       = "Internet"
    destination_address_prefix  = "VirtualNetwork"
  }

  security_rule {
    name                        = "${var.resource_pattern}-nsr-ssh-inbound"
    priority                    = 101
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "22"
    destination_port_range      = "22"
    source_address_prefix       = "Internet"
    destination_address_prefix  = "VirtualNetwork"
  }

  tags = {
    name = "${var.name}-nsg"
    environment = "${var.environment}"
    owner = "${var.resource_owner}"
    project = "${var.project}"
  }
}

# Azure virtual network
resource "azurerm_virtual_network" "vnet" {
  name                        = "${var.resource_pattern}-vnet"
  location                    = "${data.azurerm_resource_group.dev.location}"
  resource_group_name         = "${data.azurerm_resource_group.dev.name}"
  address_space               = "${var.vnet_address_space}"

  subnet {
    name            = "${var.resource_pattern}-subnet"
    address_prefix  = "${var.subnet_address_prefix}"
    security_group  = "${azurerm_network_security_group.nsg.id}"
  }

  tags = {
    name = "${var.name}-vnet"
    environment = "${var.environment}"
    owner = "${var.resource_owner}"
    project = "${var.project}"
  }
}

# Azure public ip
resource "azurerm_public_ip" "public_ip" {
  name                    = "${var.resource_pattern}-publicip"
  location                = "${data.azurerm_resource_group.dev.location}"
  resource_group_name     = "${data.azurerm_resource_group.dev.name}"
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
  domain_name_label       = "${var.name}"

  tags = {
    name = "${var.name}-publicip"
    environment = "${var.environment}"
    owner = "${var.resource_owner}"
    project = "${var.project}"
  }
}