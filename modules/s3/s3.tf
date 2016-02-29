
# S3 bucket for initial-cluster etcd proxy discovery
# and two-stage cloudinit user-data files
resource "aws_s3_bucket" "cloudinit" {
    bucket = "${var.bucket_prefix}-cloudinit"
    acl = "private"
    force_destroy = true
    tags {
        Name = "${var.cluster_name}_cloud-init"
    }
}

# S3 bucket for application configuration, code, units etcd. 
# Shared by all cluster nodes
resource "aws_s3_bucket" "config" {
    bucket = "${var.bucket_prefix}-config"
    acl = "private"
    force_destroy = true
    tags {
        Name = "${var.cluster_name}_config"
    }
}

# S3 bucket for log data backup
resource "aws_s3_bucket" "logs" {
    bucket = "${var.bucket_prefix}-logs"
    acl = "private"
    force_destroy = true
    tags {
        Name = "${var.cluster_name}_logs"
    }
}

output "s3_bucket_cloudinit" {
    value = "${aws_s3_bucket.cloudinit.bucket}"
}

output "s3_bucket_config" {
    value = "${aws_s3_bucket.config.bucket}"
}

output "s3_bucket_logs" {
    value = "${aws_s3_bucket.logs.bucket}"
}
