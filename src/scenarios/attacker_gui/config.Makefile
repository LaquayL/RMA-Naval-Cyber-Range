# Modules definition
# 	they are used in order so if a module depends on the outputs (e.g. IPs) of another it should be put as successor
MODULES += nets_attacker_gui websocket_to_websocket gui_attack # Attacker
MODULES += gui_home # GUI for MaCySTe (leave it near the end if you are leveraging the dynamic GUI functionality)
