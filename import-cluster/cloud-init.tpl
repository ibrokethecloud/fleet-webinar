#cloud-config    
resize_rootfs: true
hostname: ${node_name}
ssh_authorized_keys:
  - ${ssh_key}
runcmd:
  - 'curl  -sfL https://get.k3s.io  | sh -'
