variable "twingate_login" {
  description = "Twingate Login NAME.twingate.com"
  type = string
  default  = "fellipeveiga"
}
variable "twingate_api-token" {
  description = "Twingate API-TOKEN provided by twingate"
  type = string
  default  = "EkXjaEg5gjbh3kcgjGh2dSdc8bcZKpvUnVIuziVJwR68KkPd9BJXnqIWUjELX8zwkW-8VFvHTRsLY4CGqMWeMS6Q2gWZwUVm3vdXWxnG8DeKx6rQgEONT2gMEbnuxAGrMS60zw"
}
variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets."
  type        = list(string)
  default     = [
    "172.16.0.2/30",
    "172.16.0.6./30",
    "172.16.0.10/30",
    "172.16.0.14/30",
    "172.16.0.18/30",
    "172.16.0.22/30",
    "172.16.0.26/30",
    "172.16.0.30/30",
  ]
}
