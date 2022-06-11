build-image:
	packer build image/ubuntu-microk8s.pkr.hcl

generate-tfvars:
	sh scripts/generate-tfvars.sh

plan: generate-tfvars
	terraform plan

deploy:	generate-tfvars
	terraform apply -auto-approve