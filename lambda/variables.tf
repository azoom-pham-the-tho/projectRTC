variable "aws_region" {
	default = "us-east-1"
}

variable "accountId" {
	default = ""
}

variable "access_key" {
	default = ""
}


variable "secret_key" {
	default = "7TfXG5RKbeakheRvnZk4EVEMAlJ2QnNZ4AMhWl3d"
}

variable "function_fe" {
	default = "rtc-fe"
}
variable "function_be" {
	default = "rtc-be"
}


variable "vpc_cidr" {
	default = "10.20.0.0/16"
}

variable "subnets_cidr" {
	type = list
	default = ["10.20.1.0/24", "10.20.2.0/24"]
}
