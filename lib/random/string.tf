variable "override_special" {
  type = string
  default = ""
}

variable "length" {
  type = string
}

variable "is_upper" {
  type = bool
  default = true
}

resource "random_string" "random" {
  length           = var.length
  special          = length(var.override_special) != 0
  override_special = var.override_special
  upper = var.is_upper

}

output "result" {
  value = random_string.random.result
}
