variable "aws_region" {
	default = "us-east-1"
}

variable "access_key" {
	default = "AKIA4TSLZATUFBD5HUMV"
}

variable "secret_key" {
	default = "7TfXG5RKbeakheRvnZk4EVEMAlJ2QnNZ4AMhWl3d"
}

variable "vpc_cidr" {
	default = "10.20.0.0/16"
}

variable "subnets_cidr" {
	type = list
	default = ["10.20.1.0/24", "10.20.2.0/24"]
}
