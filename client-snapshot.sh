#!/bin/bash

curl --unix-socket /tmp/firecracker.socket -i \
   -X PATCH 'http://localhost/vm' \
   -H 'Accept: application/json' \
   -H 'Content-Type: application/json' \
   -d '{
           "state": "Paused"
   }'

curl --unix-socket /tmp/firecracker.socket -i \
   -X PUT 'http://localhost/snapshot/create' \
   -H  'Accept: application/json' \
   -H  'Content-Type: application/json' \
   -d '{
           "snapshot_type": "Full",
           "snapshot_path": "/home/pi/tests/latest/snapshots/final_base/snapshot_file",
           "mem_file_path": "/home/pi/tests/latest/snapshots/final_base/mem_file",
           "version": "1.2.0"
   }'


#curl --unix-socket /tmp/firecracker.socket -i \
#    -X PATCH 'http://localhost/vm' \
#    -H 'Accept: application/json' \
#    -H 'Content-Type: application/json' \
#    -d '{
#            "state": "Resumed"
#    }'


# curl --unix-socket /tmp/firecracker.socket -i \
#     -X PUT 'http://localhost/snapshot/create' \
#     -H  'Accept: application/json' \
#     -H  'Content-Type: application/json' \
#     -d '{
#             "snapshot_type": "Diff",
#             "snapshot_path": "/home/pi/tests/latest/snapshots/test_diff/snapshot_file",
#             "mem_file_path": "/home/pi/tests/latest/snapshots/test_diff/mem_file",
#             "version": "1.2.0"
#     }'