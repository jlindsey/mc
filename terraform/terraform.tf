provider "digitalocean" {
  version = "~> 0.1"
  token   = "${var.do_api_token}"
}

provider "template" {
  version = "~> 1.0"
}
