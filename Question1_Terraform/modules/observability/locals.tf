locals {
  monitor_diagnostic_setting = "mds-${var.department}-${var.project}-${var.company}"
  log_analytics_workspace_name = "law-${var.department}-${var.project}-${var.company}"
}
