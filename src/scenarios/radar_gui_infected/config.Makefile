# Modules definition
# 	they are used in order so if a module depends on the outputs (e.g. IPs) of another it should be put as successor
MODULES += nets_base_radar_gui # Basic networking
MODULES += ppi_asterix # ASTERIX radar
MODULES += ppi_navico   # NAVICO radar
MODULES += malware_ship_side # Attacker
MODULES += gui_home # GUI for MaCySTe (leave it near the end if you are leveraging the dynamic GUI functionality)