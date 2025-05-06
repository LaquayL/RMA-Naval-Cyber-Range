ppi_asterix_pods += gui_asterix

ppi_asterix_pod_gui_asterix_network_interfaces += eth0
ppi_asterix_pod_gui_asterix_eth0_network = BRIDGE

gui_home_pod_gui_home_manifest_extensions += $(SCENARIO_DIR)/ppi_asterix/gui_home.yaml
