# Random identifier to avoid collisions
resource "random_string" "number" {
  length  = 4
  upper   = false
  lower   = false
  numeric = true
  special = false
}

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "vnet${random_string.number.result}"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

#Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
  name = "subnet${random_string.number.result}"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes = ["10.0.1.0/24"]
}

#Create public ip

resource "azurerm_public_ip" "myterraformpublicip" {
  name = "publicip${random_string.number.result}"
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method = "Dynamic"
  domain_name_label = "ctwacademy${random_string.number.result}"
}

#Create network security group and rule

resource "azurerm_network_security_group" "myterraformnetworksecuritygroup" {
  name = "networkSecurityGroup${random_string.number.result}"
  location = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name = "SSH"
    priority = 1001
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

security_rule {

    name                       = "Prometheus"
    priority                   = 1020
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9090"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {

    name                       = "AlertManager"
    priority                   = 1040
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9093"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }

  security_rule {

    name                       = "Grafana"
    priority                   = 1060
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }
}

#Create network interface

resource "azurerm_network_interface" "myterraformnic" {
  name = "NIC${random_string.number.result}"
  location = var.resource_group_location
  resource_group_name = var.resource_group_name

    ip_configuration {
      name = "nicConfiguration${random_string.number.result}"
      subnet_id = azurerm_subnet.myterraformsubnet.id 
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.myterraformpublicip.id
    }
}

#Connect security group to nic  

resource "azurerm_network_interface_security_group_association" "securityGroupToNic" {
  network_interface_id = azurerm_network_interface.myterraformnic.id
  network_security_group_id = azurerm_network_security_group.myterraformnetworksecuritygroup.id 
}

#Create storage account 

resource "azurerm_storage_account" "mystorageaccount" {
  name = "storage${random_string.number.result}"
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  account_tier = "Standard"
  account_replication_type = "LRS"
  tags = {
    environment = "staging"
  }
}
#Create virtual machine

resource "azurerm_linux_virtual_machine" "myterraformvm" {
  name = "vm${random_string.number.result}"
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.myterraformnic.id]
  size = "Standard_D2s_v3"
  admin_username      = "ctwacademy"
  admin_ssh_key {
    username   = "ctwacademy"
    public_key = file("../resources/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  } 
}