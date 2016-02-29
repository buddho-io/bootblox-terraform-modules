module "etcd" {
    source = "../../modules/etcd"

    cluster_name = "${var.cluster_name}"

    # etcd cluster_desired_capacity should be in odd numbers, e.g. 3, 5, 9
    cluster_desired_capacity = 3
    instance_type = "t2.nano"
    keypair = "root"
    allow_ssh_cidr="0.0.0.0/0"

    # aws
    aws_account_id="${var.aws_account.id}"
    aws_region = "${var.aws_account.default_region}"

    # Note: currently etcd launch_configuration devices can NOT be changed after etcd cluster is up
    # See https://github.com/hashicorp/terraform/issues/2910
    docker_volume_size = 12
    root_volume_size = 12

    # vpc
    vpc_id = "${module.vpc.vpc_id}"
    vpc_cidr = "${module.vpc.vpc_cidr}"
    etcd_subnet_a_id = "${module.vpc.private_subnet_a_id}"
    etcd_subnet_b_id = "${module.vpc.private_subnet_b_id}"
    etcd_subnet_c_id = "${module.vpc.private_subnet_c_id}"
    etcd_subnet_az_a = "${module.vpc.private_subnet_az_a}"
    etcd_subnet_az_b = "${module.vpc.private_subnet_az_b}"
    etcd_subnet_az_c = "${module.vpc.private_subnet_az_c}"

    # s3
    s3_bucket_cloudinit = "${module.s3.s3_bucket_cloudinit}"
}