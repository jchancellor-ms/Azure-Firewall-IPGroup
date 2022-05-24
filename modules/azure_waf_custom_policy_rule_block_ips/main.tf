locals {
  cidr_range_map = csvdecode(file(var.csv_file_path))
  cidr_list      = [for element in local.cidr_range_map : trimspace(element.cidr)]
}

resource "azurerm_web_application_firewall_policy" "this" {
  name                = var.waf_policy_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  custom_rules {
    name      = var.rule_name
    priority  = 1
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RemoteAddr"
      }

      operator           = "IPMatch"
      negation_condition = false
      match_values       = local.cidr_list
    }

    action = "Block"
  }
}