###################
## Customization ##
###################
# Profile/Cluster name
export ENV := dev
export AWS_PROFILE := $(ENV)-bootblox
export CLUSTER_NAME := $(ENV)-bootblox
# To prevent you mistakenly using a wrong account (and end up destroying live environment),
# a list of allowed AWS account IDs should be defined:
#ALLOWED_ACCOUNT_IDS := "123456789012","012345678901"

export AWS_ACCOUNT := $(shell aws --profile ${AWS_PROFILE} iam get-user | jq ".User.Arn" | grep -Eo '[[:digit:]]{12}')

export AWS_REGION := us-west-2

# Working Directories
ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SCRIPTS := $(ROOT_DIR)scripts
MODULES := $(ROOT_DIR)modules
RESOURCES := $(ROOT_DIR)resources
TF_RESOURCES := $(ROOT_DIR)resources/$(ENV)/terraforms
BUILD := $(ROOT_DIR)build/$(ENV)
CONFIG := $(BUILD)/cloud-config
CERTS := $(BUILD)/certs
SITE_CERT := $(CERTS)/site.pem
POLICIES := $(BUILD)/policies

# Terraform files
TF_PORVIDER := $(BUILD)/provider.tf
TF_DESTROY_PLAN := $(BUILD)/destroy.tfplan
TF_APPLY_PLAN := $(BUILD)/destroy.tfplan
TF_STATE := $(BUILD)/terraform.tfstate

# Terraform commands
TF_GET := terraform get -update
TF_SHOW := terraform show -module-depth=1
TF_GRAPH := terraform graph -draw-cycles -verbose
TF_PLAN := terraform plan -module-depth=1
TF_APPLY := terraform apply
TF_REFRESH := terraform refresh
TF_DESTROY := terraform destroy -force
##########################
## End of customization ##
##########################

export

all: worker

help:
	@echo "Usage: make (<resource> | destroy_<resource> | plan_<resource> | refresh_<resource> | show | graph )"
	@echo "Available resources: vpc iam route53 etcd worker admiral"
	@echo "For example: make plan_worker # to show what resources are planned for worker"

destroy: 
	@echo "Usage: make destroy_<resource>"
	@echo "For example: make destroy_worker"
	@echo "Node: destroy may fail because of outstanding dependences"

destroy_all: \
	destroy_admiral \
	destroy_worker \
	destroy_etcd \
	destroy_iam \
	destroy_route53 \
	destroy_vpc

clean_all: destroy_all
	rm -f $(BUILD)/*.tf 
	#rm -f $(BUILD)/terraform.tfstate

# TODO: Push/Pull terraform states from a tf state repo
pull_tf_state:
	@mkdir -p $(BUILD)
	@echo pull terraform state from ....

push_tf_state:
	@echo push terraform state to ....

# Load all resouces makefile
include resources/makefiles/*.mk

.PHONY: all destroy destroy_all clean_all help pull_tf_state push_tf_state
