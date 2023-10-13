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
            "snapshot_type": "Diff",
            "snapshot_path": "/home/pi/tests/latest/snapshots/final_diff/thumbnail/snapshot_file",
            "mem_file_path": "/home/pi/tests/latest/snapshots/final_diff/thumbnail/mem_file",
            "version": "1.2.0"
    }'