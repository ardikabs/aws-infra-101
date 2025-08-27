# AWS Infrastructure 101 with Terraform and Terragrunt

Welcome to Infrastructure 101, your guide to our company's infrastructure. This is the main place to find all the information you need, including how everything is set up, configured, and what our best practices are. We use Terraform and Terragrunt to manage our infrastructure as code (IaC), making it efficient and easy to scale.

## Overview

This repository hosted detailed documentation, Terraform configurations, Terragrunt files, and other infrastructure-as-code (IaC) templates that meticulously describe both our cloud and on-premises infrastructure. It is thoughtfully structured to ensure ease of navigation and comprehension of our infrastructure setup, encompassing everything from network configurations to server deployments and beyond.

### Key Directories

| Directory | Purpose |
|-----------|---------|
| `modules/` | Reusable Terraform modules for provisioning and managing cloud resources |
| `resources/` | Infrastructure code organized by AWS Account |
| `hacks/` | Utility scripts for infrastructure operations, if any |

### Style Guide

The Infrastructure 101 repository follows a conventional style guide for designing the directory structure as outlined below:

- **Regional Separation**

  All resources are organized by region. Resources not bound to a specific region are placed in the global directory. For example, IAM resources can be found in `resources/<ACCOUNT_ALIAS>/global/iam/...`.

- **VPC-Scoped Resources**

  AWS resources tied to a VPC are always located within the vpcs/ directory, followed by the corresponding VPC name. For instance, ECS resources will be found at `resources/<ACCOUNT_ALIAS>/vpcs/<VPC_ALIAS>/ecs/<CLUSTER_NAME>`.

- **Mandatory Variables**

  Every resource must define the following variables:
  - `account_id`: The AWS Account ID
  - `entity_name`: The entity name the resource belongs to
  - `environment_name`: The environment the resource belongs to
  - `region`: The AWS Region

  The variables are likely already defined in an HCL file for each directory. For example, variables like `account_id`, `entity_name`, and `region` are pulled from [`cloud.hcl`](./resources/mgmt/cloud.hcl). The `environment_name` is also there. These variables in `cloud.hcl` are meant to be default values. Any specific resource can override them by defining the variable directly in its own `terragrunt.hcl` file, for example [s3/shared-bucket-987654321098/terragrunt.hcl](./resources/staging/ap-east-1/s3/shared-bucket-987654321098/terragrunt.hcl). This also applies to the [`region.hcl`](./resources/mgmt/ap-east-1/region.hcl) file, which sets default values for its specific region. We'll explain these "metadata files" in more detail in the next section.

- **Metadata Files**

  Any HCL file other than `terragrunt.hcl` serves as metadata and is later referenced by the root [`terragrunt.hcl`](./resources/terragrunt.hcl) file. For example, the [`cloud.hcl`](./resources/mgmt/cloud.hcl) file in the `mgmt` account contains metadata like:

  ```hcl
  inputs = {
    account_id       = "123456789012"
    region           = "ap-east-1" # This will be a default region on this AWS account, to override this value, you can set the region in the region.hcl file under `region` directory.
    entity_name      = "Backend"
    environment_name = "global"
  }
  ```

    This metadata is then merged into the root [`terragrunt.hcl`](./resources/terragrunt.hcl) file, allowing for reuse across the rest of the Terragrunt configurations. However, this approach is not limited to `cloud.hcl`; you might also find files like `region.hcl`, `environment.hcl`, etc. The naming convention is designed to be self-explanatory, making it clear what values are used in each context. For example, `region.hcl` contains values either overridden or specific to the regional context, while `environment.hcl` contains values specific to the environment context (e.g., `staging`).

    According to the configuration defined in the root [`terragrunt.hcl`](./resources/terragrunt.hcl) file, the following metadata files are recognized and automatically loaded during any Terragrunt operation:

  - `cloud.hcl`: Account-level settings and defaults.
  - `region.hcl`: Region-specific overrides and configurations.
  - `environment.hcl`: Environment-specific settings (dev, staging, prod)
  - `team.hcl`: Team-specific configurations and ownership details
