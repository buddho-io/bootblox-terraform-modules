
# subnet for public cluster

variable "public_subnet_a" { default = "10.0.30.0/24" }
variable "public_subnet_b" { default = "10.0.31.0/24" }
variable "public_subnet_c" { default = "10.0.32.0/24" }
variable "public_subnet_az_a" { default = "us-west-2a" }
variable "public_subnet_az_b" { default = "us-west-2b" }
variable "public_subnet_az_c" { default = "us-west-2c" }

resource "aws_subnet" "public_a" {
    vpc_id = "${aws_vpc.cluster_vpc.id}"
    availability_zone = "${var.public_subnet_az_a}"
    cidr_block = "${var.public_subnet_a}"
    map_public_ip_on_launch = "true"
    tags {
        Name = "${var.cluster_name}-public_a"
    }
}

resource "aws_route_table_association" "public_rt_a" {
    subnet_id = "${aws_subnet.public_a.id}"
    route_table_id = "${aws_route_table.cluster_vpc.id}"
}

resource "aws_subnet" "public_b" {
    vpc_id = "${aws_vpc.cluster_vpc.id}"
    availability_zone = "${var.public_subnet_az_b}"
    cidr_block = "${var.public_subnet_b}"
    map_public_ip_on_launch = "true"
    tags {
        Name = "${var.cluster_name}-public_b"
    }
}

resource "aws_route_table_association" "public_rt_b" {
    subnet_id = "${aws_subnet.public_b.id}"
    route_table_id = "${aws_route_table.cluster_vpc.id}"
}

resource "aws_subnet" "public_c" {
    vpc_id = "${aws_vpc.cluster_vpc.id}"
    availability_zone = "${var.public_subnet_az_c}"
    cidr_block = "${var.public_subnet_c}"
    map_public_ip_on_launch = "true"
    tags {
        Name = "${var.cluster_name}-public_c"
    }
}

resource "aws_route_table_association" "public_rt_c" {
    subnet_id = "${aws_subnet.public_c.id}"
    route_table_id = "${aws_route_table.cluster_vpc.id}"
}

output "public_subnet_a_id" { value = "${aws_subnet.public_a.id}" }
output "public_subnet_b_id" { value = "${aws_subnet.public_b.id}" }
output "public_subnet_c_id" { value = "${aws_subnet.public_c.id}" }
output "public_subnet_az_a" { value = "${var.public_subnet_az_a}" }
output "public_subnet_az_b" { value = "${var.public_subnet_az_b}" }
output "public_subnet_az_c" { value = "${var.public_subnet_az_c}" }
