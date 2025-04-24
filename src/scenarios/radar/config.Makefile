# Modules definition
# 	they are used in order so if a module depends on the outputs (e.g. IPs) of another it should be put as successor
MODULES += nets_base_radar # Basic networking
MODULES += radar_converter_asterix # ASTERIX radar
MODULES += radar_converter_navico # NAVICO radar