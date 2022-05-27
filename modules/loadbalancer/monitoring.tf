


//////////////////////////////////////////////////////[ MONITORING ALERT ]////////////////////////////////////////////////


# # ---------------------------------------------------------------------------------------------------------------------#
# Create monitoring alert for cpu
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_monitor_alert" "lbaas_cpu" {
  alerts {
    email = [var.alert_email]
  }
  window      = "5m"
  type        = "v1/insights/lbaas/avg_cpu_utilization_percent"
  compare     = "GreaterThan"
  value       = 90
  enabled     = true
  entities    = [digitalocean_loadbalancer.this.id]
  description = "Alert about CPU usage for loadbalancer @ ${var.project.name}"
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create monitoring alert for connections
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_monitor_alert" "lbaas_connections" {
  alerts {
    email = [var.alert_email]
  }
  window      = "5m"
  type        = "v1/insights/lbaas/connection_utilization_percent"
  compare     = "GreaterThan"
  value       = 90
  enabled     = true
  entities    = [digitalocean_loadbalancer.this.id]
  description = "Alert about connections usage for loadbalancer @ ${var.project.name}"
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create monitoring alert for tls connections
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_monitor_alert" "lbaas_tls_connections" {
  alerts {
    email = [var.alert_email]
  }
  window      = "5m"
  type        = "v1/insights/lbaas/tls_connections_per_second_utilization_percent"
  compare     = "GreaterThan"
  value       = 90
  enabled     = true
  entities    = [digitalocean_loadbalancer.this.id]
  description = "Alert about tls connections usage for loadbalancer @ ${var.project.name}"
}

