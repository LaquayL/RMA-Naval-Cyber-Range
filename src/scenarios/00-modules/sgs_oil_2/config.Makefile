sgs_oil_2_pods += openplc

sgs_oil_2_pod_openplc_network_interfaces += eth0
sgs_oil_2_pod_openplc_eth0_network = BRIDGE

sgs_oil_2_pod_openplc_manifest_extensions += $(SCENARIO_DIR)/sgs_oil_2/pod.yaml
