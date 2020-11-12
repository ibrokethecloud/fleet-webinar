#cloud-config    
resize_rootfs: true
hostname: ${node_name}
ssh_authorized_keys:
  - ${ssh_key}
runcmd:
  - 'curl  -sfL https://get.rancher.io  | sh -'
  - 'systemctl enable rancherd-server'
  - 'systemctl start rancherd-server'
  - 'curl -sfL https://raw.githubusercontent.com/ibrokethecloud/rancherd-bootstrap/master/rancherdsetup.sh | sh -'
  - 'curl -so /var/lib/rancher/rke2/server/manifests/local-path-storage.yaml https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml'
