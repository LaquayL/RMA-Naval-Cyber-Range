autopilot_pods += autopilot

autopilot_pod_autopilot_network_interfaces += eth0 nats0
autopilot_pod_autopilot_eth0_network = BRIDGE
autopilot_pod_autopilot_nats0_network = NATS
