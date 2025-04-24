# Modules definition
# 	they are used in order so if a module depends on the outputs (e.g. IPs) of another it should be put as successor
MODULES += nets_base_bridge_demux # Basic networking
MODULES += nats_relay_2
MODULES += rtu_ai rtu_gp rtu_he rtu_ii rtu_ra rtu_sd rtu_ti # RTUs