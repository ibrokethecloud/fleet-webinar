#cloud-config    
resize_rootfs: true
hostname: ${node_name}
ssh_authorized_keys:
  - ${ssh_key}
write_files:
- content: |
    apiVersion: v1
    kind: Namespace
    metadata:
      name: vault-glue-operator
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: vault-token
      namespace: vault-glue-operator
    type: Opaque
    data:
      token: ${vault_token}
    ---
    apiVersion: vault.cattle.io/v1alpha1
    kind: Register
    metadata:
      name: external-secrets
    spec:
      vaultAddr: ${vault_addr}
      serviceAccount: external-secrets-kubernetes-external-secrets
      namespace: kube-external-secrets
      sslDisable: true
      vaultPolicy:
        - fleet-demo
      roleName: fleet-demo
  path: /var/lib/rancher/k3s/server/manifests/vaultToken.yaml
runcmd:
  - sudo mkdir -p /var/lib/rancher/k3s/server/manifests
  - sudo wget --no-check-certificate --output-document /var/lib/rancher/k3s/server/manifests/import.yaml ${manifest_url}
  - 'curl  -sfL https://get.k3s.io  | INSTALL_K3S_CHANNEL=${channel} sh -'
