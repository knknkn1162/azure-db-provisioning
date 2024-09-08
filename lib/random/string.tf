variable "override_special" {
  type = string
  default = ""
}

variable "length" {
  type = string
}

resource "random_string" "random" {
  length           = var.length
  special          = true
  override_special = var.override_special
}

output "result" {
  value = random_string.random.result
}