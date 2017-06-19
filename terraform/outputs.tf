output "instance_ip" {
  value = "${digitalocean_droplet.minecraft.ipv4_address}"
}

output "floating_ip" {
  value = "${digitalocean_floating_ip.minecraft.ip_address}"
}
