output "grp" {
  value = {
    for k, v in nsxt_policy_group.grp : k => { "display_name" = v.display_name, "path" = v.path }
  }
}