#!/bin/bash

start_vmready=$(expr `date +%s%N` / 1000)

curl --unix-socket /tmp/firecracker.socket -i \
     -X PUT 'http://localhost/snapshot/load' \
     -H  'Accept: application/json' \
     -H  'Content-Type: application/json' \
     -d '{
             "snapshot_path": "/home/pi/tests/latest/snapshots/final_base/snapshot_file",
             "mem_backend": {
                 "backend_path": "/home/pi/tests/latest/snapshots/final_base/mem_file",
                 "backend_type": "File"
             },
             "enable_diff_snapshots": false,
             "resume_vm": true
     }'

end_vmready=$(expr `date +%s%N` / 1000)

vmready_in=`expr $end_vmready - $start_vmready`

echo 'VM READY in:'
echo $vmready_in



# curl --unix-socket /tmp/firecracker.socket -i \
#      -X PUT 'http://localhost/snapshot/load' \
#      -H  'Accept: application/json' \
#      -H  'Content-Type: application/json' \
#      -d '{
#              "snapshot_path": "/home/pi/tests/latest/snapshots/final_base/snapshot_file",
#              "mem_backend": {
#                  "backend_path": "/home/pi/tests/latest/snapshots/final_base/mem_file",
#                  "backend_type": "File"
#              },
#              "enable_diff_snapshots": false,   #######################
#              "resume_vm": true
#      }'