![microk8s](https://dashboard.snapcraft.io/site_media/appmedia/2018/11/b8a85a31-MicroK8s_SnapStore_icon.png)
# MicroK8s on AWS EC2
### _On AWS with Terraform_

**Required:**
- Terraform
- Packer
- kubectl
- AWS CLI

**Other requirements:**

Tag the subnet you would like the instances deployed in with: `Name:default-subnet`

**Initialise:**
```
terraform init
```

**Build AMI:**
```
make build-image
```

**Plan:**
```
make plan
```

**Deploy:**
```
make deploy
```