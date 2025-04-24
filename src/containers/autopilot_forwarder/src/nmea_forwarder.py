import socket
import asyncio
import os
import pynmea2

MULTICAST_GROUP = os.getenv("NMEA_MULTICAST_GROUP", "239.0.1.1")
MULTICAST_PORT = int(os.getenv("NMEA_MULTICAST_PORT", 10110))
AUTOPILOT_TCP_HOST = os.getenv("NMEA_TCP_LISTENER_HOST", "192.168.1.1")
AUTOPILOT_TCP_PORT = int(os.getenv("NMEA_TCP_LISTENER_PORT", 5000))

ALLOWED_NMEA_TYPES = {"APB", "HDT", "VTG", "XTE"}

async def forward_nmea():
    print(f"Listening for multicast NMEA on {MULTICAST_GROUP}:{MULTICAST_PORT}")

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.bind(("", MULTICAST_PORT))
    mreq = socket.inet_aton(MULTICAST_GROUP) + socket.inet_aton("0.0.0.0")
    sock.setsockopt(socket.IPPROTO_IP, socket.IP_ADD_MEMBERSHIP, mreq)

    print(f"Opening TCP connection to autopilot at {AUTOPILOT_TCP_HOST}:{AUTOPILOT_TCP_PORT}")
    reader, writer = await asyncio.open_connection(AUTOPILOT_TCP_HOST, AUTOPILOT_TCP_PORT)
    print(f"Forwarding NMEA to {AUTOPILOT_TCP_HOST}:{AUTOPILOT_TCP_PORT}")

    loop = asyncio.get_running_loop()
    while True:
        data, _ = sock.recvfrom(1024)
        nmea_sentence = data.decode(errors="ignore").strip()
        print(f"Received: {nmea_sentence}")

        try:
            parsed_sentence = pynmea2.parse(nmea_sentence, check=False)
            sentence_type = parsed_sentence.sentence_type

            # Filter based on allowed sentence types
            if sentence_type in ALLOWED_NMEA_TYPES:
                print(f"Forwarding: {nmea_sentence}")
                writer.write(nmea_sentence.encode() + b'\n')
                await writer.drain()
            else:
                print(f"Ignored: {nmea_sentence}")

        except pynmea2.ParseError:
            print(f"Invalid NMEA sentence: {nmea_sentence}")

asyncio.run(forward_nmea())
