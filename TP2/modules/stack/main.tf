resource "terraform_data" "env" {
  triggers_replace = {
    instance_count    = var.instance_count
    instance_type     = var.instance_type
    region            = var.region
    enable_monitoring = var.enable_monitoring
    tags              = var.tags
  }
}