import socket
import json
import pickle
import time
from datetime import datetime

handshake = b'CONNECT 52\n'

###################### first handshake ######################

sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

sock.connect('./worker-52.sock')

print("Connected to first AF_VSOCK server")

sock.sendall(handshake)

### dev ###
response = sock.recv(14)
print("First handshake's response")
print(response)
### dev ###

sock.close()

#############################################################
