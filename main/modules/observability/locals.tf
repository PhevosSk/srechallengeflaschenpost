locals {
  resource_group_name = "rg-${var.team}-${var.project}-${var.company}"
  monitor_diagnostic_setting = "mds-${var.team}-${var.project}-${var.company}"
}