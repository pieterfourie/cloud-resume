variable "region" {
  type    = string
  default = "eu-north-1"
}

variable "project_name" {
  type    = string
  default = "cloud-resume"
}

variable "table_name" {
  type    = string
  default = "visitor_count"
}

variable "primary_key" {
  type    = string
  default = "id"
}

variable "primary_key_value" {
  type    = string
  default = "site_visits"
}
