import asyncio
import logging
import os
import pynmea2
from pynmea2.types.talker import APB, HDT, VTG, XTE

from state import AUTOPILOT_STATE

async def handle_client(reader, writer):
    logger = logging.getLogger("handle_client")
    while True:
        try:
            data = await reader.read(1024)
            if not data:
                break
            nmea_sentence = data.decode(errors="ignore").strip()
            logger.info(f"Received NMEA: {nmea_sentence}")
            print(f"Received NMEA: {nmea_sentence}")
            try:
                sentence = pynmea2.parse(nmea_sentence, check=False)
            except pynmea2.ParseError:
                # Attempt to split and parse multiple sentences if the direct parse fails
                if "$" in nmea_sentence:
                    parts = [f"${s}" for s in nmea_sentence.split("$") if s]
                    for part in parts:
                        try:
                            sentence = pynmea2.parse(part.strip(), check=False)
                            # If successful, you may process the sentence here
                            print(f"Successfully parsed: {sentence}")
                        except pynmea2.ParseError as e:
                            print(f"Failed to parse split sentence: {part.strip()} -- Reason: {e}")
                            pass

            if isinstance(sentence, APB):
                AUTOPILOT_STATE.track_control_xte = float(sentence.cross_track_err_mag)
                AUTOPILOT_STATE.track_control_xte_direction_to_steer = sentence.dir_steer
                AUTOPILOT_STATE.track_control_set_heading = float(sentence.heading_to_dest)
            elif isinstance(sentence, HDT):
                AUTOPILOT_STATE.heading = float(sentence.heading)
            elif isinstance(sentence, VTG):
                if sentence.spd_over_grnd_kts is not None:
                    AUTOPILOT_STATE.speed = float(sentence.spd_over_grnd_kts)
            elif isinstance(sentence, XTE):
                AUTOPILOT_STATE.track_control_xte = float(sentence.cross_track_err_dist)
                AUTOPILOT_STATE.track_control_xte_direction_to_steer = sentence.correction_dir
            else:
                logger.debug(f"Ignored {sentence}")
        except Exception as e:
            logger.error(f"Error reading data: {e}")
            break

async def listen_nmea():
    logger = logging.getLogger("listen_nmea")
    tcp_host = os.getenv('NMEA_TCP_LISTENER_HOST', '0.0.0.0')
    tcp_port = int(os.getenv('NMEA_TCP_LISTENER_PORT', 5000))  # Change this if needed

    server = await asyncio.start_server(handle_client, tcp_host, tcp_port)
    logger.info(f"Listening for NMEA TCP on {tcp_host}:{tcp_port}")
    print(f"Listening for NMEA TCP on {tcp_host}:{tcp_port}")

    async with server:
        await server.serve_forever()







# import asyncio
# import logging
# import os
# import socket
# import struct

# from state import AUTOPILOT_STATE

# import pynmea2
# from pynmea2.types.talker import APB, HDT, VTG, XTE

# async def listen_nmea():
#   logger = logging.getLogger(listen_nmea.__name__)
#   bind_host = os.getenv('NMEA_HOST', '0.0.0.0')
#   bind_port = int(os.getenv('NMEA_PORT', 10110))
#   bind_addr = (bind_host, bind_port)
#   with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
#     sock.bind(bind_addr)
#     logger.info('Listening for NMEA on %s', bind_addr)
#     sock.setblocking(False)

#     mreq = struct.pack("4sl", socket.inet_aton(bind_host), socket.INADDR_ANY)
#     sock.setsockopt(socket.IPPROTO_IP, socket.IP_ADD_MEMBERSHIP, mreq)

#     loop = asyncio.get_running_loop()
#     while True:
#       nmea = await loop.sock_recv(sock, 255)
#       try:
#         sentence = pynmea2.parse(nmea.decode(errors = 'ignore'), check = False)
#         if isinstance(sentence, APB):
#           AUTOPILOT_STATE.track_control_xte = float(sentence.cross_track_err_mag)
#           AUTOPILOT_STATE.track_control_xte_direction_to_steer = sentence.dir_steer
#           AUTOPILOT_STATE.track_control_set_heading = float(sentence.heading_to_dest)
#         elif isinstance(sentence, HDT):
#           AUTOPILOT_STATE.heading = float(sentence.heading)
#         elif isinstance(sentence, VTG):
#           if sentence.spd_over_grnd_kts is not None:
#             AUTOPILOT_STATE.speed = float(sentence.spd_over_grnd_kts)
#         elif isinstance(sentence, XTE):
#           AUTOPILOT_STATE.track_control_xte = float(sentence.cross_track_err_dist)
#           AUTOPILOT_STATE.track_control_xte_direction_to_steer = sentence.correction_dir
#         else:
#           logger.debug(f'Ignored {sentence}')
#       except ValueError:
#         logger.exception('Falied parsing NMEA')