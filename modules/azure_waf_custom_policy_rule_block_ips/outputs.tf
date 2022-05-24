output "policy_id" {
  value = azurerm_web_application_firewall_policy.this.id
}

output "rule_cidr_list" {
  value = local.cidr_list
}