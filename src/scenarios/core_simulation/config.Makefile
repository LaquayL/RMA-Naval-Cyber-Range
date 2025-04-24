# Modules definition
# 	they are used in order so if a module depends on the outputs (e.g. IPs) of another it should be put as successor
MODULES += nets_base_simulation # Basic networking
MODULES += nats # NATS message broker