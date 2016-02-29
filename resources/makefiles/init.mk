show: | $(BUILD)
	cd $(BUILD); $(TF_SHOW)

show_state: init
	cat $(BUILD)/terraform.tfstate

graph: | $(BUILD)
	cd $(BUILD); $(TF_GRAPH)

refresh: init
	cd $(BUILD); $(TF_REFRESH)

init: | $(TF_PORVIDER)

$(BUILD): init_build_dir

$(TF_PORVIDER): update_provider

$(SITE_CERT): gen_certs

init_build_dir:
	@mkdir -p $(BUILD)
	@cp -rf $(RESOURCES)/cloud-config $(BUILD)
	@cp -rf $(RESOURCES)/policies $(BUILD)
	@$(SCRIPTS)/substitute.sh -k "AWS-ACCOUNT" -v "$(AWS_ACCOUNT)" $(CONFIG)/*.yaml $(POLICIES)/*.json
	@$(SCRIPTS)/substitute.sh -k "CLUSTER-NAME" -v "$(CLUSTER_NAME)" $(CONFIG)/*.yaml $(POLICIES)/*.json

update_provider: | $(BUILD)
	# Generate tf provider
	$(SCRIPTS)/gen-provider.sh > $(TF_PORVIDER)

gen_certs: $(BUILD)
	@cp -rf $(RESOURCES)/certs $(BUILD)
	@if [ ! -f "$(SITE_CERT)" ] ; \
	then \
		$(MAKE) -C $(CERTS) ; \
	fi

clean_certs:
	rm -f $(CERTS)/*.pem
	
.PHONY: init show show_state graph refresh update_provider init_build_dir
.PHONY: gen_certs clean_certs