#!/usr/bin/env python3

from importlib import import_module
import os
import struct
import json
from subprocess import run, Popen
import time
import socket
import pickle
from datetime import datetime

import sys
import syscalls_pb2


# for language snapshot
#####################################################################

print(socket.gethostname())

print(socket.VMADDR_CID_HOST)

VSOCKPORT = 52
sock = socket.socket(socket.AF_VSOCK, socket.SOCK_STREAM)
hostaddr = (socket.VMADDR_CID_ANY, VSOCKPORT)

sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

sock.bind(hostaddr)
print("prin tin listen")
sock.listen()
print("prin tin accept")

client_socket, client_addr = sock.accept()
print(f"Accepted connection from {client_addr}")
# handshakeMd = client_socket.recv(11)

#####################################################################

# mount appfs and load application
run(["mount", "-r", "/dev/vdb", "/srv"], executable="/bin/mount")
app = import_module('workload')
print("... just loaded application")


# for function diff snapshot
#####################################################################

print("prin tin 2i accept, for diff snapshot")

client_socket2, client_addr2 = sock.accept()
print(f"Accepted connection from {client_addr2}")
# handshakeMd2 = client_socket2.recv(11)

#####################################################################

requestData = client_socket2.recv(2048)
print("Meta tin recv")
# requestData = client_socket2.recv(1716, socket.MSG_WAITALL)
print(requestData)

# start = time.monotonic_ns()
start = datetime.now()
responseJson = {}

request = json.loads(requestData)

try:
	payload = request['payload']
	# print("the stripped down request: " + str(payload))
	responseJson = app.handle(payload)
except:
	responseJson = { 'error': str(sys.exec_info()) }

responseJson['duration'] = (datetime.now() - start).microseconds

# print(responseJson)

responseData = pickle.dumps(responseJson)
client_socket2.sendall(responseData)
