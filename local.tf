locals {
  project = trimspace("${var.project_name}-${var.project_environment}")

  current_timestamp = timestamp()
  today             = formatdate("YYYYMMDD-hhmmss", local.current_timestamp)
}
