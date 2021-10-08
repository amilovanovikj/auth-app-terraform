variable env {
	type = map
}

variable "appinsights_instrumentation_key" {
  type = string
  sensitive = true
}

variable "appinsights_connection_string" {
  type = string
  sensitive = true
}