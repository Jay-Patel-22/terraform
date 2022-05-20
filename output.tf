output "zookeeper_name" {
  value = google_compute_instance.zookeeper.*.name
}

output "instance_ids" {
  value = google_compute_instance.zookeeper.*.id
}