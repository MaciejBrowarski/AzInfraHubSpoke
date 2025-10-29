#
# Tenant ID
#
variable "tenant_id" {
  type = string
}
#
# subscription map
#
variable "subscription_list" {
  type = map(string)
}

variable "location" {
  type = string
}



