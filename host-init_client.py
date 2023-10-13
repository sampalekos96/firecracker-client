import socket
import json
import pickle
import time
from datetime import datetime

handshake = b'CONNECT 52\n'

###################################### REQUESTS ######################################

sent_req = {"time": 15, "user_id": 2, "function":"thumbnail", "payload":{"img": "libertybell.jpg", "size": [128, 128]}}

# sent_req = {"time": 15, "user_id": 2, "function":"audio-fingerprint", "payload":{"audio": "audio.wav"}}

# sent_req = {"time": 15, "user_id": 2, "function":"image-enhance", "payload":{"img": "libertybell.jpg", "op": "sharpness", "factor": 0.5}}

# sent_req = {"time": 15, "user_id": 1, "function":"lorempy2", "payload" : {"value": "lorempy2-1"}}

# sent_req = {"time": 50, "user_id": 1, "function":"sentiment-analysis", "payload" : {"analyse": "We hold these truths to be self-evident, that all men are created equal, that they are endowed by their Creator with certain unalienable Rights, that among these are Life, Liberty and the pursuit of Happiness.--That to secure these rights, Governments are instituted among Men, deriving their just powers from the consent of the governed, --That whenever any Form of Government becomes destructive of these ends, it is the Right of the People to alter or to abolish it, and to institute new Government, laying its foundation on such principles and organizing its powers in such form, as to them shall seem most likely to effect their Safety and Happiness. Prudence, indeed, will dictate that Governments long established should not be changed for light and transient causes; and accordingly all experience hath shewn, that mankind are more disposed to suffer, while evils are sufferable, than to right themselves by abolishing the forms to which they are accustomed. But when a long train of abuses and usurpations, pursuing invariably the same Object evinces a design to reduce them under absolute Despotism, it is their right, it is their duty, to throw off such Government, and to provide new Guards for their future security.--Such has been the patient sufferance of these Colonies; and such is now the necessity which constrains them to alter their former Systems of Government. The history of the present King of Great Britain is a history of repeated injuries and usurpations, all having in direct object the establishment of an absolute Tyranny over these States. To prove this, let Facts be submitted to a candid world."}}

# sent_req = {"time": 15, "user_id": 2, "function":"hello", "payload" :{"img": "pitontable.png"}}

###################################### REQUESTS ######################################


###################### first handshake (made by base script) ######################

# sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

# sock.connect('./worker-52.sock')

# print("Connected to first AF_VSOCK server")

# sock.sendall(handshake)

# ### dev ###
# response = sock.recv(14)
# print("First handshake's response")
# print(response)
# ### dev ###

# sock.close()

#############################################################

sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

sock.connect('./worker-52.sock')

print("Connected to second AF_VSOCK server")

sock.sendall(handshake)
response = sock.recv(14)
print("Second handshake's response")
print(response)

start = datetime.now()

# These data are received before 2nd accept --> problem
sock.sendall(str.encode(json.dumps(sent_req)))

response2 = b""
while True:
	packet = sock.recv(4096)
	if not packet:
		break
	response2 += packet

request_in = (datetime.now() - start).microseconds

print("TO REQUEST IN:")
print(request_in)

print(pickle.loads(response2))
