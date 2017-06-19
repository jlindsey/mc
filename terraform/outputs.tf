output "ip" {
  value = "${digitalocean_floating_ip.minecraft.ip_address}"
}
