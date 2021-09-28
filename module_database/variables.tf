variable env {
	type = map
}

variable subnet_id {
  type = string
}

variable sql_login {
  type        = string
  description = "The SQL sysadmin username for MariaDB"
}

variable sql_password {
  type        = string
  sensitive   = true
  description = "The SQL sysadmin password for MariaDB"
}