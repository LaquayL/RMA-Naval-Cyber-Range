helm_pod_modbus_nats_kv_client_extra_vars += \
	pod_name \
	modbus_host \
	nats_bucket \
	nats_key \
	nats_url \
	value_multiplier \
	modbus_holding_register

helm_pod_modbus_nats_kv_client_extra_var_pod_name = helm
helm_pod_modbus_nats_kv_client_extra_var_modbus_host = $(sgs_master_pod_openplc_eth0_ip)
helm_pod_modbus_nats_kv_client_extra_var_nats_bucket = ship_controls
helm_pod_modbus_nats_kv_client_extra_var_nats_key = rudder
helm_pod_modbus_nats_kv_client_extra_var_value_multiplier = 35
helm_pod_modbus_nats_kv_client_extra_var_modbus_holding_register = 1130

helm_pod_modbus_nats_kv_client_extra_var_nats_url = nats://$(nats_relay_1_pod_nats_eth0_ip):4222