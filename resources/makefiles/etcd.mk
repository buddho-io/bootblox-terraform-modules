
etcd: vpc s3 iam plan_etcd upload_etcd_userdata
	cd $(BUILD); \
		$(TF_APPLY) -target module.etcd
	@$(MAKE) etcd_ips

plan_etcd: plan_vpc plan_s3 plan_iam init_etcd
	cd $(BUILD); \
		$(TF_PLAN) -target module.etcd;

refresh_etcd: | $(TF_PORVIDER)
	cd $(BUILD); \
		$(TF_REFRESH) -target module.etcd
	@$(MAKE) etcd_ips

destroy_etcd: | $(TF_PORVIDER)
	cd $(BUILD); \
		$(TF_DESTROY) -target module.etcd.aws_autoscaling_group.etcd; \
		$(TF_DESTROY) -target module.etcd.aws_launch_configuration.etcd; \
		$(TF_DESTROY) -target module.etcd 

clean_etcd: destroy_etcd
	rm -f $(BUILD)/module-etcd.tf

init_etcd: init
	cp -rf $(RESOURCES)/terraform/$(ENV)/module-etcd.tf $(BUILD)
	cd $(BUILD); \
		$(TF_GET); \
		for i in $$(ls .terraform/modules/*/Makefile); do i=$$(dirname $$i); make -C $$i; done

upload_etcd_userdata: init_build_dir
	cd $(BUILD); \
		$(SCRIPTS)/gen-userdata.sh etcd $(CONFIG)/cloudinit-etcd.def

etcd_ips:
	@echo "etcd public ips: " `$(SCRIPTS)/get-ec2-public-ip.sh $(CLUSTER_NAME)_etcd`

.PHONY: etcd destroy_etcd refresh_etcd plan_etcd init_etcd clean_etcd upload_etcd_userdata etcd_ips
