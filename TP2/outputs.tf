output "all_envs" {
  value = [ for env in module.envs : env.env_infos ]
}