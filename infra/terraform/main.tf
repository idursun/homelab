module "k3s" {
  source       = "./modules/k3s"
  target_node  = "homelab"
  ciuser       = "idursun"
  ssh_key_file = "~/.ssh/id_rsa.pub"
}
