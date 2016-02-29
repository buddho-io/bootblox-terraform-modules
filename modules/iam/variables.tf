
variable "env" { default = "dev" }
variable "cluster_name" { default = "dev-bootblox" }
variable "aws_account_id" { }
variable "aws_account_region" { }
variable "aws_account_user" { }
variable "deployment_user" { default = "deployment" }
variable "cloud_config_file_path" { default = "cloud-config/aws-files.yaml" }
