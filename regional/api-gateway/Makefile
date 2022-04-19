.ONESHELL:
.SHELL := /usr/bin/bash
.PHONY: apply destroy plan-destroy plan prep format check-security lint documentation
WORKSPACE="$(ENV)-$(REGION)"
TF_VAR_FILES="$(PROJECT_ROOT)/env/$(ENV)/$(REGION).tfvars"
CURRENT_FOLDER=$(shell basename "$$(pwd)")
BOLD=$(shell tput bold)
RED=$(shell tput setaf 1)
GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
RESET=$(shell tput sgr0)

# Check for necessary tools
ifeq (, $(shell which aws))
	$(error "No aws in $(PATH), go to https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html, pick your OS, and follow the instructions")
endif
ifeq (, $(shell which jq))
	$(error "No jq in $(PATH), please install jq")
endif
ifeq (, $(shell which terraform))
	$(error "No terraform in $(PATH), get it from https://www.terraform.io/downloads.html")
endif

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

set-env:
	@if [ -z $(ENV) ]; then \
		echo "$(BOLD)$(RED)ENV was not set$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ -z $(REGION) ]; then \
		echo "$(BOLD)$(RED)REGION was not set$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ -z $(AWS_PROFILE) ]; then \
		echo "$(BOLD)$(RED)AWS_PROFILE was not set.$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ ! -z $${ERROR} ] && [ $${ERROR} -eq 1 ]; then \
		echo "$(BOLD)Example usage: \`AWS_PROFILE=whatever ENV=demo REGION=us-east-2 make plan\`$(RESET)"; \
		exit 1; \
	 fi
	@if [ ! -f "$(TF_VAR_FILES)" ]; then \
		echo "$(BOLD)$(RED)Could not find variables file: $(TF_VAR_FILES)$(RESET)"; \
		exit 1; \
	 fi
	@if [ -z $(PROJECT_ROOT) ]; then \
		echo "$(BOLD)$(RED)PROJECT_ROOT was not set$(RESET)"; \
		ERROR=1; \
	 fi

prep: set-env ## Prepare a new workspace (environment) if needed, configure the tfstate backend, update any modules, and switch to the workspace
	$(eval bucket_prefix=$(shell aws sts get-caller-identity --query 'Account' --output text --profile "$(AWS_PROFILE)"))
	@echo "$(BOLD)Configuring the terraform backend$(RESET)"
	@terraform init \
		-input=false \
		-force-copy \
		-get=true \
		-backend=true \
		-backend-config="profile=$(AWS_PROFILE)" \
		-backend-config="region=$(REGION)" \
		-backend-config="bucket=$(bucket_prefix)-$(REGION)-tfstate" \
		-backend-config="key=regional/$(CURRENT_FOLDER)/terraform.tfstate" \
		-backend-config="dynamodb_table=$(ENV)-$(REGION)-lock-table" \
	    -backend-config="acl=private"

	@echo "$(BOLD)Switching to workspace $(WORKSPACE)$(RESET)"
	@terraform workspace select $(WORKSPACE) || terraform workspace new $(WORKSPACE)

plan: prep ## Show what terraform thinks it will do
	@terraform plan \
		-lock=true \
		-input=false \
		-refresh=true \
		-var region="${REGION}" \
        -var aws_profile="${PROFILE}" \
        -state="terraform-$(ENV)-$(REGION).tfstate" \
        -var-file="$(TF_VAR_FILES)"

format: prep ## Rewrites all Terraform configuration files to a canonical format.
	@terraform fmt \
		-write=true \
		-recursive

lint: prep ## Check for possible errors, best practices, etc in current directory!
	@tflint

check-security: prep ## Static analysis of your terraform templates to spot potential security issues.
	@tfsec .

documentation: prep ## Generate README.md for a module
	@terraform-docs \
		markdown table \
		--sort-by required  . > README.md

plan-destroy: prep ## Creates a destruction plan.
	@terraform plan \
		-input=false \
		-refresh=true \
		-destroy \
		-var region="${REGION}" \
		-var aws_profile="${PROFILE}" \
		-state="terraform-$(ENV)-$(REGION).tfstate" \
		-var-file="$(TF_VAR_FILES)"

apply: prep ## Have terraform do the things. This will cost money.
	@terraform apply \
		-auto-approve \
		-lock=true \
		-input=false \
		-refresh=true \
		-var region="${REGION}" \
		-var aws_profile="${PROFILE}" \
		-state="terraform-$(ENV)-$(REGION).tfstate" \
		-var-file="$(TF_VAR_FILES)"

destroy: prep ## Destroy the things
	@terraform destroy \
		-lock=true \
		-input=false \
		-refresh=true \
		-var region="${REGION}" \
		-var aws_profile="${PROFILE}" \
		-state="terraform-$(ENV)-$(REGION).tfstate" \
		-var-file="$(TF_VAR_FILES)"