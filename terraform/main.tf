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

resource "digitalocean_floating_ip" "minecraft" {
  droplet_id = "${digitalocean_droplet.minecraft.id}"
  region     = "${digitalocean_droplet.minecraft.region}"
}

locals {
  split_fqdn = "${split(".", var.domain_name)}"
  domain     = "${join(".", slice(local.split_fqdn, length(local.split_fqdn) - 2, length(local.split_fqdn)))}"
}

resource "digitalocean_record" "minecraft" {
  domain = "${local.domain}"
  type   = "A"
  name   = "${var.domain_name}"
  ttl    = "3600"
  value  = "${digitalocean_floating_ip.minecraft.ip_address}"
}
