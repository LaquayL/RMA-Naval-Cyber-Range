# Modules definition
# 	they are used in order so if a module depends on the outputs (e.g. IPs) of another it should be put as successor
MODULES += nets_attacker_gui
MODULES += websocket_to_websocket_radar gui_attack_radar # Attacker GUI with radar target
MODULES += websocket_to_websocket_wecdis gui_attack_wecdis # Attacker GUI with wecdis target
