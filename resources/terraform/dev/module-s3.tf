module "s3" {
    source = "../../modules/s3"
    bucket_prefix="${var.aws_account.id}-${var.cluster_name}"
    cluster_name = "${var.cluster_name}"
}
