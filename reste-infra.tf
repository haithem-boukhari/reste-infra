data "azurerm_subnet" "example3" {
  name                 = "testsubnet3"
  virtual_network_name = "VnetProjet"
  resource_group_name  = "projetfinalHaiXav"
}

data "azurerm_subnet" "example4" {
  name                 = "testsubnet4"
  virtual_network_name = "VnetProjet"
  resource_group_name  = "projetfinalHaiXav"
}

resource "azurerm_network_security_group" "mytestnsg" {
  name                = "nsgProjettest"
  location            = "West Europe"
  resource_group_name = "projetfinalHaiXav"
 
 security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "inbound"
    access                     = "allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
 
 security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
 security_rule {                                                                                                       
    name                       = "port-HTTP"
    priority                   = 1003                                                                                    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"                                                                                   source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "mytestPubIp" {
  name                = "testpubip"
  location            = "West Europe"
  resource_group_name = "projetfinalHaiXav"
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "mytestNIC" {
  name                = "nameNICtest"
  location            = "West Europe"
  resource_group_name = "projetfinalHaiXav"
  network_security_group_id = "${azurerm_network_security_group.mytestnsg.id}"

  ip_configuration {
    name                          = "nameNICConfig3"
    subnet_id                     = "${data.azurerm_subnet.example3.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            =  "10.0.3.8"
    public_ip_address_id          = "${azurerm_public_ip.mytestPubIp.id}"
  }
}


resource "azurerm_virtual_machine" "mytestVm" {
  name                  = "vm3serverTest"
  location            = "West Europe"
  resource_group_name = "projetfinalHaiXav"
  network_interface_ids = ["${azurerm_network_interface.mytestNIC.id}"]
  vm_size               = "Standard_B1ms"

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "Centos"
    sku       = "7.6"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisktest"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "serverTest"
    admin_username = "stage"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/stage/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6a/uzxbYZ/ro68ep79lRCpseThOLNifdSUFf81+f3p1WYoBi7ysVImc3tAPmO1QlQikm6Zqsdq9NAwZNWI/x1y6YrcQnttfWldBl0oo5eWNjTw+Oq//W8Y135Yo7uE4JbApOu1acqRVDaGr+jrlDynu7QLW6wseRi59SQUDf2hyvC3TfamVUWItHkOy2ihM/aJ+qlgOcud110QTyPmrWanPwUCDnQF7IRvInw5wDbNF9Oj0bG/+Ro8Dei9OKhyD8LyFQSLU09n8tCcpe2DWNcK47dgp+AB1bT/vqiyofeYWHSvTHpstzKoA6Ky3xQCue/bjDTivg8KIygU9QNysW1 vagrant@localhost.localdomain"
    }
 }
}

#################################

resource "azurerm_network_security_group" "mybdnsg" {
  name                = "nsgProjetbd"
  location            = "West Europe"
  resource_group_name = "projetfinalHaiXav"
 
 security_rule {
    name                       = "BD"
    priority                   = 1010
    direction                  = "inbound"
    access                     = "allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "27017"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


 security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "inbound"
    access                     = "allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
 
 security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
 security_rule {                                                                                                       
    name                       = "port-HTTP"
    priority                   = 1003                                                                                    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"                                                                                   source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}



resource "azurerm_network_interface" "mybdNIC" {
  name                = "nameNICbd"
  location            = "West Europe"
  resource_group_name = "projetfinalHaiXav"
  network_security_group_id = "${azurerm_network_security_group.mybdnsg.id}"

  ip_configuration {
    name                          = "nameNICConfig4"
    subnet_id                     = "${data.azurerm_subnet.example4.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            =  "10.0.4.10"
    
  }
}


resource "azurerm_virtual_machine" "mybdVm" {
  name                  = "vm4BD"
  location            = "West Europe"
  resource_group_name = "projetfinalHaiXav"
  network_interface_ids = ["${azurerm_network_interface.mybdNIC.id}"]
  vm_size               = "Standard_B1ms"

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "Centos"
    sku       = "7.6"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdiskbd"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "serverBD"
    admin_username = "stage"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/stage/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6a/uzxbYZ/ro68ep79lRCpseThOLNifdSUFf81+f3p1WYoBi7ysVImc3tAPmO1QlQikm6Zqsdq9NAwZNWI/x1y6YrcQnttfWldBl0oo5eWNjTw+Oq//W8Y135Yo7uE4JbApOu1acqRVDaGr+jrlDynu7QLW6wseRi59SQUDf2hyvC3TfamVUWItHkOy2ihM/aJ+qlgOcud110QTyPmrWanPwUCDnQF7IRvInw5wDbNF9Oj0bG/+Ro8Dei9OKhyD8LyFQSLU09n8tCcpe2DWNcK47dgp+AB1bT/vqiyofeYWHSvTHpstzKoA6Ky3xQCue/bjDTivg8KIygU9QNysW1 vagrant@localhost.localdomain"
    }
 }
}

#################################