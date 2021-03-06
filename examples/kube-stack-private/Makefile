.PHONY: generate-ssh-key network plan apply test destroy

.DEFAULT_GOAL = help

## Use envsubst and project.env to render terraform-tfvars.tpl into terraform.tfvars
render-tfvars:
	@. ./vars.env && envsubst <terraform-tfvars.tpl > terraform.tfvars

## Use ssh-keygen to generate a keypair for SSH
generate-ssh-key:
	@ssh-keygen -q -N "" -b 4096 -C "kube-stack" -f ./id_rsa

## Use Terraform to create the VPC and core network resources in a specific order based on module VPC, Scenario 2
network:
	@terraform init
	@terraform plan -out tf.out -target=module.vpc.module.vpc
	@terraform apply tf.out
	@terraform plan -out tf.out -target=module.vpc.module.public-subnets
	@terraform apply tf.out
	@terraform plan -out tf.out -target=module.vpc.module.public-gateway
	@terraform apply tf.out
	@terraform plan -out tf.out -target=module.vpc.module.private-subnets
	@terraform apply tf.out
	@terraform plan -out tf.out -target=module.vpc.module.nat-gateway
	@terraform apply tf.out

## Use Terraform to generate a planfile tf.out
plan:
	@terraform plan -out=tf.out

## Use Terraform to apply the tf.out planfile
apply:
	@terraform apply tf.out

## Use Terraform to destory all resources in the test env
destroy:
	@terraform destroy -force

## rm -rf everything
clean: destroy
	@rm -rf terraform.tfstate terraform.tfstate.backup .terraform
	@rm -rf tf.out

## Show help screen.
help:
	@echo "Please use \`make <target>' where <target> is one of\n\n"
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "%-30s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)