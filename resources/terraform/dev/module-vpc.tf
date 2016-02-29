
module "vpc" {
    source = "../../modules/vpc"
    vpc_cidr = "10.0.0.0/16"
    vpc_name = "${var.cluster_name}_vpc"
    vpc_region = "${var.aws_account.default_region}"
    cluster_name = "${var.cluster_name}"
    
/*
# the following can be configured. See ../modules/vpc for default values
    private_subnet_a = <cdir value>
    private_subnet_b = <cdir value>
    private_subnet_c = <cdir value>

    public_subnet_a = <cdir value>
    public_subnet_b = <cdir value>
    public_subnet_c = <cdir value>
*/

    private_subnet_az_a  = "${var.aws_account.default_region}a"
    private_subnet_az_b  = "${var.aws_account.default_region}b"
    private_subnet_az_c  = "${var.aws_account.default_region}c"

    public_subnet_az_a  = "${var.aws_account.default_region}a"
    public_subnet_az_b  = "${var.aws_account.default_region}b"
    public_subnet_az_c  = "${var.aws_account.default_region}c"
}