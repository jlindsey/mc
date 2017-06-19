resource "digitalocean_ssh_key" "minecraft" {
  name       = "Minecraft"
  public_key = "${file("/Users/jl2243/.ssh/minecraft.pub")}"
}

resource "digitalocean_droplet" "minecraft" {
  name    = "minecraft"
  region  = "nyc3"
  image   = "ubuntu-16-04-x64"
  size    = "4gb"
  ssh_keys = ["${digitalocean_ssh_key.minecraft.id}"]
}

resource "digitalocean_floating_ip" "minecraft" {
  droplet_id = "${digitalocean_droplet.minecraft.id}"
  region     = "${digitalocean_droplet.minecraft.region}"
}
