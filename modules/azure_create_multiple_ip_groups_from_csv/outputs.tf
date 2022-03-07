output "ip_group_ids" {
  value = values(module.create_ip_groups)[*].ip_group_id
}