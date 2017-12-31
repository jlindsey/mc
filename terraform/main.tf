data "template_file" "cloud_init" {
  template = "${file("${path.module}/cloud-config.yml")}"

  vars {
    fqdn = "${var.domain_name}"
  }
}

resource "digitalocean_ssh_key" "minecraft" {
  name       = "Minecraft"
  public_key = "${file("${var.do_ssh_key_path}")}"
}

resource "digitalocean_droplet" "minecraft" {
  name      = "${var.domain_name}"
  region    = "nyc3"
  image     = "ubuntu-16-04-x64"
  size      = "4gb"
  ssh_keys  = ["${digitalocean_ssh_key.minecraft.id}"]
  user_data = "${data.template_file.cloud_init.rendered}"
}

locals {
  split_fqdn  = "${split(".", var.domain_name)}"
  domain      = "${join(".", slice(local.split_fqdn, length(local.split_fqdn) - 2, length(local.split_fqdn)))}"
  domain_name = "${replace(replace(var.domain_name, local.domain, ""), ".", "")}"
}

resource "digitalocean_record" "minecraft" {
  domain = "${local.domain}"
  type   = "A"
  name   = "${local.domain_name}"
  ttl    = "300"
  value  = "${digitalocean_droplet.minecraft.ipv4_address}"
}
