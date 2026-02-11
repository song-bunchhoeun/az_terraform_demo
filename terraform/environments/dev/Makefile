# ============================================================================
# Terraform Makefile for EKYC Infrastructure
# ============================================================================

.PHONY: help init plan apply destroy validate fmt clean output

# Default target
.DEFAULT_GOAL := help

# Variables
ENV ?= dev
PLAN_FILE := ekyc.${ENV}.tfplan

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)EKYC Terraform Commands$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-20s$(NC) %s\n", $$1, $$2}'

init: ## Initialize Terraform with backend configuration
	@echo "$(BLUE)Initializing Terraform with backend configuration...$(NC)"
	terraform init -backend-config=../../backend_config/dev.hcl

init-upgrade: ## Initialize Terraform and upgrade providers
	@echo "$(BLUE)Initializing Terraform with provider upgrade...$(NC)"
	terraform init -upgrade -backend-config=../../backend_config/dev.hcl

validate: ## Validate Terraform configuration
	@echo "$(BLUE)Validating Terraform configuration...$(NC)"
	terraform validate

fmt: ## Format Terraform files
	@echo "$(BLUE)Formatting Terraform files...$(NC)"
	terraform fmt -recursive

fmt-check: ## Check if Terraform files are formatted
	@echo "$(BLUE)Checking Terraform formatting...$(NC)"
	terraform fmt -check -recursive

plan: validate ## Create Terraform execution plan
	@echo "$(BLUE)Creating Terraform plan...$(NC)"
	terraform plan -out=$(PLAN_FILE)

plan-destroy: validate ## Create Terraform destroy plan
	@echo "$(YELLOW)Creating Terraform destroy plan...$(NC)"
	terraform plan -destroy -out=$(PLAN_FILE)

apply: ## Apply Terraform changes
	@echo "$(GREEN)Applying Terraform changes...$(NC)"
	@if [ -f $(PLAN_FILE) ]; then \
		terraform apply $(PLAN_FILE); \
		rm -f $(PLAN_FILE); \
	else \
		echo "$(RED)No plan file found. Run 'make plan' first.$(NC)"; \
		exit 1; \
	fi

apply-auto: validate ## Apply Terraform changes without plan file (auto-approve)
	@echo "$(YELLOW)Applying Terraform changes (auto-approve)...$(NC)"
	terraform apply -auto-approve

destroy: ## Destroy Terraform-managed infrastructure
	@echo "$(RED)Destroying Terraform-managed infrastructure...$(NC)"
	@echo "$(YELLOW)WARNING: This will destroy all resources!$(NC)"
	@read -p "Are you sure? Type 'yes' to confirm: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		terraform destroy; \
	else \
		echo "$(GREEN)Destroy cancelled.$(NC)"; \
	fi

destroy-auto: ## Destroy Terraform-managed infrastructure (auto-approve)
	@echo "$(RED)Destroying Terraform-managed infrastructure (auto-approve)...$(NC)"
	terraform destroy -auto-approve

output: ## Show Terraform outputs
	@echo "$(BLUE)Terraform Outputs:$(NC)"
	terraform output

output-json: ## Show Terraform outputs in JSON format
	@echo "$(BLUE)Terraform Outputs (JSON):$(NC)"
	terraform output -json

show: ## Show Terraform state
	@echo "$(BLUE)Terraform State:$(NC)"
	terraform show

state-list: ## List resources in Terraform state
	@echo "$(BLUE)Resources in Terraform state:$(NC)"
	terraform state list

refresh: ## Refresh Terraform state
	@echo "$(BLUE)Refreshing Terraform state...$(NC)"
	terraform refresh

clean: ## Clean up temporary files
	@echo "$(BLUE)Cleaning up temporary files...$(NC)"
	rm -f $(PLAN_FILE)
	rm -f terraform.tfstate.backup
	rm -rf .terraform.tfstate.lock.info

clean-all: clean ## Clean up all Terraform files (including .terraform)
	@echo "$(RED)Cleaning up all Terraform files...$(NC)"
	rm -rf .terraform
	rm -f .terraform.lock.hcl

graph: ## Generate Terraform dependency graph
	@echo "$(BLUE)Generating Terraform dependency graph...$(NC)"
	terraform graph | dot -Tpng > graph.png
	@echo "$(GREEN)Graph saved to graph.png$(NC)"

console: ## Open Terraform console
	@echo "$(BLUE)Opening Terraform console...$(NC)"
	terraform console

import: ## Import existing resource (usage: make import RESOURCE=azurerm_resource_group.rg ID=/subscriptions/.../resourceGroups/...)
	@if [ -z "$(RESOURCE)" ] || [ -z "$(ID)" ]; then \
		echo "$(RED)Error: RESOURCE and ID are required$(NC)"; \
		echo "Usage: make import RESOURCE=azurerm_resource_group.rg ID=/subscriptions/.../resourceGroups/..."; \
		exit 1; \
	fi
	@echo "$(BLUE)Importing resource $(RESOURCE)...$(NC)"
	terraform import $(RESOURCE) $(ID)

taint: ## Taint a resource (usage: make taint RESOURCE=azurerm_resource_group.rg)
	@if [ -z "$(RESOURCE)" ]; then \
		echo "$(RED)Error: RESOURCE is required$(NC)"; \
		echo "Usage: make taint RESOURCE=azurerm_resource_group.rg"; \
		exit 1; \
	fi
	@echo "$(YELLOW)Tainting resource $(RESOURCE)...$(NC)"
	terraform taint $(RESOURCE)

untaint: ## Untaint a resource (usage: make untaint RESOURCE=azurerm_resource_group.rg)
	@if [ -z "$(RESOURCE)" ]; then \
		echo "$(RED)Error: RESOURCE is required$(NC)"; \
		echo "Usage: make untaint RESOURCE=azurerm_resource_group.rg"; \
		exit 1; \
	fi
	@echo "$(BLUE)Untainting resource $(RESOURCE)...$(NC)"
	terraform untaint $(RESOURCE)

unlock: ## Force unlock Terraform state (usage: make unlock LOCK_ID=xxx)
	@if [ -z "$(LOCK_ID)" ]; then \
		echo "$(RED)Error: LOCK_ID is required$(NC)"; \
		echo "Usage: make unlock LOCK_ID=xxx"; \
		exit 1; \
	fi
	@echo "$(YELLOW)Force unlocking Terraform state...$(NC)"
	terraform force-unlock $(LOCK_ID)

check: fmt-check validate ## Run all checks (format and validate)
	@echo "$(GREEN)All checks passed!$(NC)"

docs: ## Generate documentation
	@echo "$(BLUE)Generating documentation...$(NC)"
	@if command -v terraform-docs >/dev/null 2>&1; then \
		terraform-docs markdown table . > TERRAFORM.md; \
		echo "$(GREEN)Documentation generated in TERRAFORM.md$(NC)"; \
	else \
		echo "$(YELLOW)terraform-docs not installed. Install from: https://terraform-docs.io/$(NC)"; \
	fi

cost: ## Estimate infrastructure costs (requires infracost)
	@echo "$(BLUE)Estimating infrastructure costs...$(NC)"
	@if command -v infracost >/dev/null 2>&1; then \
		infracost breakdown --path .; \
	else \
		echo "$(YELLOW)infracost not installed. Install from: https://www.infracost.io/$(NC)"; \
	fi

security: ## Run security scan (requires tfsec)
	@echo "$(BLUE)Running security scan...$(NC)"
	@if command -v tfsec >/dev/null 2>&1; then \
		tfsec .; \
	else \
		echo "$(YELLOW)tfsec not installed. Install from: https://github.com/aquasecurity/tfsec$(NC)"; \
	fi

lint: ## Run linting (requires tflint)
	@echo "$(BLUE)Running linting...$(NC)"
	@if command -v tflint >/dev/null 2>&1; then \
		tflint --init; \
		tflint; \
	else \
		echo "$(YELLOW)tflint not installed. Install from: https://github.com/terraform-linters/tflint$(NC)"; \
	fi

all: check plan ## Run checks and create plan
	@echo "$(GREEN)Ready to apply!$(NC)"
