output "project" {
  value = var.project
}

output "location" {
  value = var.location
}

output "instances" {
  value = [for index, instance in google_compute_instance.application : {
    name             = instance.name
    external_address = var.enableExternalIP ? google_compute_address.external[index].address : null
  }]
}