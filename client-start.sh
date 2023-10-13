#!/bin/bash

# arch='uname -m'
kernel_path='/home/pi/tests/preview_vmlinux.bin'
rootfs_path='/home/pi/tests/latest/pythonfs_van.ext4'
appfs_path='/home/pi/tests/latest/appfs/thumbnail/output.ext2'

start_vmready=$(expr `date +%s%N` / 1000)

curl --unix-socket /tmp/firecracker.socket -i \
   -X PUT 'http://localhost/boot-source'   \
   -H 'Accept: application/json'           \
   -H 'Content-Type: application/json'     \
   -d "{
         \"kernel_image_path\": \"${kernel_path}\",
         \"boot_args\": \"keep_bootcon console=ttyS0 reboot=k panic=1 pci=off\"
       }"

curl --unix-socket /tmp/firecracker.socket -i \
  -X PUT 'http://localhost/drives/rootfs' \
  -H 'Accept: application/json'           \
  -H 'Content-Type: application/json'     \
  -d "{
        \"drive_id\": \"rootfs\",
        \"path_on_host\": \"${rootfs_path}\",
        \"is_root_device\": true,
        \"is_read_only\": false
   }"

curl --unix-socket /tmp/firecracker.socket -i \
  -X PUT 'http://localhost/drives/appfs' \
  -H 'Accept: application/json'           \
  -H 'Content-Type: application/json'     \
  -d "{
        \"drive_id\": \"appfs\",
        \"path_on_host\": \"${appfs_path}\",
        \"is_root_device\": false,
        \"is_read_only\": false
   }"

curl --unix-socket /tmp/firecracker.socket -i \
  -X PUT 'http://localhost/vsock' \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
      "guest_cid": 52,
      "uds_path": "/home/pi/tests/latest/worker-52.sock"
  }'

# to manually listen for connections on host (on same dir) we exec --> nc -lkU worker-100.sock_1234

curl --unix-socket /tmp/firecracker.socket -i  \
    -X PUT 'http://localhost/machine-config' \
    -H 'Accept: application/json'            \
    -H 'Content-Type: application/json'      \
    -d '{
            "vcpu_count": 1,
            "mem_size_mib": 128,
            "smt": false,
            "track_dirty_pages": false
    }'

curl --unix-socket /tmp/firecracker.socket -i \
  -X PUT 'http://localhost/network-interfaces/eth0' \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
      "iface_id": "eth0",
      "guest_mac": "AA:FC:00:00:00:01",
      "host_dev_name": "tap0"
    }'

curl --unix-socket /tmp/firecracker.socket -i \
  -X PUT 'http://localhost/actions'       \
  -H  'Accept: application/json'          \
  -H  'Content-Type: application/json'    \
  -d '{
      "action_type": "InstanceStart"
   }'


end_vmready=$(expr `date +%s%N` / 1000)

vmready_in=`expr $end_vmready - $start_vmready`

echo 'VM READY in:'
echo $vmready_in