provider "equinix" {
  client_id     = var.equinix_client_id
  client_secret = var.equinix_client_secret
}

module "vsrx-sdwan" {
  source               = "equinix/vsrx-sdwan/equinix"
  version              = "1.0.0-beta"
  name                 = "tf-vsrx-sdwan"
  hostname             = "vsrx-pri"
  metro_code           = var.metro_code_primary
  platform             = "small"
  software_package     = "STD"
  term_length          = 1
  notifications        = ["test@test.com"]
  additional_bandwidth = 50
  acl_template_id      = equinix_network_acl_template.vsrx-pri.id
  ssh_key = {
    username = "john"
    key_name = equinix_network_ssh_key.john.name
  }
  secondary = {
    enabled              = true
    metro_code           = var.metro_code_secondary
    hostname             = "vsrx-sec"
    additional_bandwidth = 50
    acl_template_id      = equinix_network_acl_template.vsrx-sec.id
  }
}

resource "equinix_network_ssh_key" "john" {
  name       = "johnKent"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDpXGdxljAyPp9vH97436U171cX2gRkfPnpL8ebrk7ZBeeIpdjtd8mYpXf6fOI0o91TQXZTYtjABzeRgg6/m9hsMOnTHjzWpFyuj/hiPuiie1WtT4NffSH1ALQFX//zouBLmdNiYFMLfEVPZleergAqsYOHGCiQuR6Qh5j0yc5Wx+LKxiRZyjsSqo+EB8V6xBXi2i5PDJXK+dYG8YU9vdNeQdB84HvTWcGEnLR5w7pgC74pBVwzs3oWLy+3jWS0TKKtflmryeFRufXq87gEkC1MOWX88uQgjyCsemuhPdN++2WS57gu7vcqCMwMDZa7dukRS3JANBtbs7qQhp9Nw2PB4q6tohqUnSDxNjCqcoGeMNg/0kHeZcoVuznsjOrIDt0HgUApflkbtw1DP7Epfc2MJ0anf5GizM8UjMYiXEvv2U/qu8Vb7d5bxAshXM5nh67NSrgst9YzSSodjUCnFQkniz6KLrTkX6c2y2gJ5c9tWhg5SPkAc8OqLrmIwf5jGoHGh6eUJy7AtMcwE3iUpbrLw8EEoZDoDXkzh+RbOtSNKXWV4EAXsIhjQusCOWWQnuAHCy9N4Td0Sntzu/xhCZ8xN0oO67Cqlsk98xSRLXeg21PuuhOYJw0DLF6L68zU2OO0RzqoNq/FjIsltSUJPAIfYKL0yEefeNWOXSrasI1ezw== john@hades"
}

resource "equinix_network_acl_template" "vsrx-pri" {
  name        = "tf-vsrx-pri"
  description = "Primary Juniper vSRX SD-WAN ACL template"
  metro_code  = var.metro_code_primary
  inbound_rule {
    subnets  = ["193.39.0.0/16", "12.16.103.0/24"]
    protocol = "TCP"
    src_port = "any"
    dst_port = "22"
  }
}

resource "equinix_network_acl_template" "vsrx-sec" {
  name        = "tf-vsrx-sec"
  description = "Secondary Juniper vSRX SD-WAN ACL template"
  metro_code  = var.metro_code_secondary
  inbound_rule {
    subnets  = ["193.39.0.0/16", "12.16.103.0/24"]
    protocol = "TCP"
    src_port = "any"
    dst_port = "22"
  }
}
