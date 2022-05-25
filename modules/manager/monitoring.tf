


//////////////////////////////////////////////////////[ MONITORING ALERT ]////////////////////////////////////////////////


# # ---------------------------------------------------------------------------------------------------------------------#
# Create monitoring alert for cpu
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_monitor_alert" "cpu" {
  alerts {
    email = [var.alert_email]
  }
  window      = "5m"
  type        = "v1/insights/droplet/cpu"
  compare     = "GreaterThan"
  value       = 90
  enabled     = true
  entities    = concat(
    [digitalocean_droplet.manager.id],
    [var.frontend_id],
    var.services_ids
    )
  description = "Alert about CPU usage for services @ ${var.project_name}"
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create monitoring alert for memory
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_monitor_alert" "memory" {
  alerts {
    email = [var.alert_email]
  }
  window      = "5m"
  type        = "v1/insights/droplet/memory_utilization_percent"
  compare     = "GreaterThan"
  value       = 90
  enabled     = true
  entities    = concat(
    [digitalocean_droplet.manager.id],
    [var.frontend_id],
    var.services_ids
    )
  description = "Alert about RAM usage for services @ ${var.project_name}"
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create monitoring alert for disk
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_monitor_alert" "disk" {
  alerts {
    email = [var.alert_email]
  }
  window      = "5m"
  type        = "v1/insights/droplet/disk_utilization_percent"
  compare     = "GreaterThan"
  value       = 90
  enabled     = true
  entities    = concat(
    [digitalocean_droplet.manager.id],
    [var.frontend_id],
    var.services_ids
    )
  description = "Alert about DISK usage for services @ ${var.project_name}"
}
