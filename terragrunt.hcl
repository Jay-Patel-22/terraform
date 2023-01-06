
terraform {
  source = "git::https://github.com/Jay-Patel-22/terraform.git//module"
}

inputs = {
  # "idfy-equitas-prod-pictor-janus-media-server-streams"
  project_id  = "idfy-299017"
  network_project_id = "idfy-299017"
  zookeeper_name = "zookeeper"
  machine_type   = "e2-medium"
  image_name  = "docker-clickhouse"
  image_project_id = "idfy-299017"
  cluster_zone  = "asia-south1-a"
  service_account_id = "terraform-task@idfy-299017.iam.gserviceaccount.com"
  zookeeper_instance_count = 3
}
