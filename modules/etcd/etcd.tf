#
# etcd cluster autoscale group configurations
#

module "ami" {
  source = "github.com/terraform-community-modules/tf_aws_coreos_ami"
  region = "${var.aws_region}"
  channel = "stable"
  virttype = "hvm"
}

resource "aws_autoscaling_group" "etcd" {
  name = "${var.cluster_name}_etcd"
  availability_zones = [ 
    "${var.etcd_subnet_az_a}", 
    "${var.etcd_subnet_az_b}", 
    "${var.etcd_subnet_az_c}"
  ]
  min_size = "${var.cluster_min_size}"
  max_size = "${var.cluster_max_size}"
  desired_capacity = "${var.cluster_desired_capacity}"
  
  health_check_type = "EC2"
  force_delete = true
  
  launch_configuration = "${aws_launch_configuration.etcd.name}"
  vpc_zone_identifier = [
    "${var.etcd_subnet_a_id}",
    "${var.etcd_subnet_b_id}",
    "${var.etcd_subnet_c_id}"
  ]

  tag {
    key = "Name"
    value = "${var.cluster_name}_etcd"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "etcd" {
  # use system generated name to allow changes of launch_configuration
  # name = "etcd-${var.ami}"
  name_prefix = "${var.cluster_name}_etcd-"
  image_id = "${module.ami.ami_id}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.etcd.name}"
  security_groups = [ "${aws_security_group.etcd.id}" ]
  key_name = "${var.keypair}"  
  lifecycle { create_before_destroy = true }
  depends_on = [ "aws_iam_instance_profile.etcd", "aws_security_group.etcd" ]

  # /root
  root_block_device = {
    volume_type = "gp2"
    volume_size = "${var.root_volume_size}" 
  }
  # /var/lib/docker
  ebs_block_device = {
    device_name = "/dev/sdb"
    volume_type = "gp2"
    volume_size = "${var.docker_volume_size}" 
  }

  lifecycle {
    create_before_destroy = true
  }
  
  user_data = "${replace(replace(file("cloud-config/scripts/s3-cloudconfig-bootstrap.sh"), "ROLE", "etcd"), "CLOUDINIT_BUCKET", var.s3_bucket_cloudinit)}"
}

# setup the etcd ec2 profile, role and polices
resource "aws_iam_instance_profile" "etcd" {
    name = "${var.cluster_name}_etcd"
    roles = ["${aws_iam_role.etcd.name}"]
    depends_on = [ "aws_iam_role.etcd" ]
}

resource "aws_iam_role_policy" "etcd_policy" {
    name = "${var.cluster_name}_etcd_policy"
    role = "${aws_iam_role.etcd.id}"
    policy = "${file(\"policies/etcd_policy.json\")}"
    depends_on = [ "aws_iam_role.etcd" ]
}

resource "aws_iam_role" "etcd" {
    name = "${var.cluster_name}_etcd"
    path = "/"
    assume_role_policy =  "${file(\"policies/assume_role_policy.json\")}"
}
