
# subnet for private cluster

variable "private_subnet_a" { default = "10.0.20.0/24" }
variable "private_subnet_b" { default = "10.0.21.0/24" }
variable "private_subnet_c" { default = "10.0.22.0/24" }
variable "private_subnet_az_a" { default = "us-west-2a" }
variable "private_subnet_az_b" { default = "us-west-2b" }
variable "private_subnet_az_c" { default = "us-west-2c" }

resource "aws_subnet" "private_a" {
    vpc_id = "${aws_vpc.cluster_vpc.id}"
    availability_zone = "${var.private_subnet_az_a}"
    cidr_block = "${var.private_subnet_a}"
    map_public_ip_on_launch = "true"
    tags {
        Name = "${var.cluster_name}-private_a"
    }
}

resource "aws_route_table_association" "private_rt_a" {
    subnet_id = "${aws_subnet.private_a.id}"
    route_table_id = "${aws_route_table.cluster_vpc.id}"
}

resource "aws_subnet" "private_b" {
    vpc_id = "${aws_vpc.cluster_vpc.id}"
    availability_zone = "${var.private_subnet_az_b}"
    cidr_block = "${var.private_subnet_b}"
    map_public_ip_on_launch = "true"
    tags {
        Name = "${var.cluster_name}-private_b"
    }
}

resource "aws_route_table_association" "private_rt_b" {
    subnet_id = "${aws_subnet.private_b.id}"
    route_table_id = "${aws_route_table.cluster_vpc.id}"
}

resource "aws_subnet" "private_c" {
    vpc_id = "${aws_vpc.cluster_vpc.id}"
    availability_zone = "${var.private_subnet_az_c}"
    cidr_block = "${var.private_subnet_c}"
    map_public_ip_on_launch = "true"
    tags {
        Name = "${var.cluster_name}-private_c"
    }
}

resource "aws_route_table_association" "private_rt_c" {
    subnet_id = "${aws_subnet.private_c.id}"
    route_table_id = "${aws_route_table.cluster_vpc.id}"
}

output "private_subnet_a_id" { value = "${aws_subnet.private_a.id}" }
output "private_subnet_b_id" { value = "${aws_subnet.private_b.id}" }
output "private_subnet_c_id" { value = "${aws_subnet.private_c.id}" }
output "private_subnet_az_a" { value = "${var.private_subnet_az_a}" }
output "private_subnet_az_b" { value = "${var.private_subnet_az_b}" }
output "private_subnet_az_c" { value = "${var.private_subnet_az_c}" }
