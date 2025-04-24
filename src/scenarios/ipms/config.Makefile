# Modules definition
# 	they are used in order so if a module depends on the outputs (e.g. IPs) of another it should be put as successor
MODULES += nets_base_ins_plc # Basic networking
MODULES += nats_relay_1
MODULES += engine_sim_plc_l engine_sim_plc_r # Engine fictitious PLCs
MODULES += engine_telegraph_l engine_telegraph_r # Engine telegraphs
MODULES += steering_gear_physics sgs_pump_1 sgs_pump_2 sgs_oil_1 sgs_oil_2 sgs_oil_tank sgs_master # SGS simulator
MODULES += helm # Rudder actuator
MODULES += autopilot # Autopilot system