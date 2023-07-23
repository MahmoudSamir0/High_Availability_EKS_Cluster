variable "subnet_name_az1" {
  type = list(any)
}
variable "subnet_name_az2" {
  type = list(any)
}
variable "subnet_id_az1" {
  type = list(any)
}

variable "subnet_id_az2" {
  type = list(any)
}
variable "nat-name" {
  type = string

}
variable "route-nat" {
  type = string
}
variable "rout-public" {
  type = string
}
variable "internet-get" {
  type = string
}

variable "true-and-false" {
  type = list(any)
}
