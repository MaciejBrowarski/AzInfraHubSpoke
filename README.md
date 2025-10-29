# AzInfraHubSpoke
Azure Infrastructure Landing Zone with hub and spoke network

This project is to install from scratch Azure Network Infrastructure in Hub and Spoke architecture.

Each resource has two files:
*.tf - with Terraform code
*.auto.tfvars - with resource configuration

if you don't need some resources, just add suffix (.e.g. _old) then this resource will be not review by OpenTofu engine.

Configuration for particular resources are held in *.auto.tfvars files.

In config.tfvars put region name, Tenant ID and subscription ID.

Example of config.tfvars file:
# BEGIN config.tfvars
tenant_id = "<TENANT_ID>

subscription_list = {
  "MAIN" = "<SUBSCRIPTION ID>";
}

location = "<REGION>"

#END config.tfvars

Main:
- Hub has only necessary Infrastructure (Virtual Network Gateway, Firewall)
- Support Infrastructures (like DNS) are installed in dedicated Spoke - Infra


Resource Group:
backup - for Microsoft backup
network - for VNET, subnet, RT, NSG, public IP resources
server - for servers and local disks
storage - for Microsoft Storage


