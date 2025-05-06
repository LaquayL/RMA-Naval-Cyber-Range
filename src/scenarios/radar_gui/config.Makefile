# Modules definition
# 	they are used in order so if a module depends on the outputs (e.g. IPs) of another it should be put as successor
MODULES += nets_base_radar_gui # Basic networking
MODULES += ppi_asterix # ASTERIX radar
MODULES += ppi_navico   # NAVICO radar