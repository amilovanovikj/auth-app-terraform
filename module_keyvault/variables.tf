variable env {
	type = map
}

variable subnet_id {
  type = string
}

variable backend_id {
  type = string
}

variable frontend_id {
  type = string
}

variable redis_key {
  type      = string
  sensitive = true
}
