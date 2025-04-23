module "envs" {
  for_each = { for env, env_details in var.environments : env => env_details }
  source   = "./modules/stack"

  instance_count    = each.value.instance_count
  instance_type     = each.value.instance_type
  region            = each.value.region
  enable_monitoring = each.value.enable_monitoring
  tags              = each.value.tags

}