locals {
    ingress_rules = [{
        port = 22
        description = "this is for ssh"
    },
    {
        port = 80
        description = "this is for http"
    },
    {
        port = 443
        description = "this is for https"
    }]
}

# variable "sg_name" {
#   type = string
#   default = "wanderlust-project"
# }
variable "instance_type" {
  type = string
  default = "t2.large"
}
variable "tags" {
  type = string
  default = "wanderlust-project"
}