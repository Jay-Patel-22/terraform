variable "project_id" {
  type        = string
  description = "Project name for the terraform"
  default = "idfy-299017"
}

variable "network_project_id" {
  type        = string
  description = "Network Project name"
  default = "idfy-299017"
}

variable "zookeeper_name" {
  type        = string
  description = "zookeeper VM Instance name"
  default = "zookeeper"
}

variable "machine_type" {
  type        = string
  description = "The machine type to create."
  default = "e2-medium"
}

#variable "network_name" {
#  type        = string
#  description = "The name of the VPC network being created"
#}
#
#variable "subnet_name" {
#  type        = string
#  description = "The name of the subnet of VPC network"
#}

variable "image_name" {
  type        = string
  description = "Google VM image name"
  default = "docker-clickhouse"
}

variable "image_project_id" {
  type        = string
  description = "Project from where to load image from"
  default = "idfy-299017"
}

variable "cluster_zone" {
  type        = string
  description = "Zone for zookeeper, same as cluster zone"
  default = "asia-south1-a"
}

variable "service_account_id" {
  type        = string
  description = "The account id that is used to generate the service account email address"
  default = "terraform-task@idfy-299017.iam.gserviceaccount.com"
}

#variable "cluster_region" {
#  type        = string
#  description = "region for our cluster"
#}

variable "zookeeper_instance_count" {
  type       = number
  description= "number of instances"
  default = 3
}
