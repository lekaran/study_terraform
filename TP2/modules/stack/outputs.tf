output "env_infos" {
  value = "${var.instance_count} d'instance de type ${var.instance_type} dans la région ${var.region}, ${var.enable_monitoring ? "il y a du monitoring" : "il n'y a pas de monitoring"}, chaque instance à les tags : ${join(",",[for k, v in var.tags : "${k}=${v}"])}"
}