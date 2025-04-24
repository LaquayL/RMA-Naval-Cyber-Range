nats_relay_1_pod_nats_extra_vars += \
	nats_config_file \
	nats_pod_host \
	nats_js_store_dir

nats_relay_1_pod_nats_extra_var_nats_config_file = $(CONFIG_DIR)/nats/nats-relay-1.conf
nats_relay_1_pod_nats_extra_var_nats_pod_host = $(nats_pod_nats_eth0_ip)
nats_relay_1_pod_nats_extra_var_nats_js_store_dir = $(nats_relay_1_pod_nats_state_dir_nats)

nats_relay_1_url ?= nats://$(nats_relay_1_pod_nats_eth0_ip):4222
nats_relay_1_ws_url ?= ws://$(nats_relay_1_pod_nats_eth0_ip):80
