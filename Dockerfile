ARG TERRAFORM_VERSION="1.5.2"

# Use the official HashiCorp Terraform image as a base
FROM hashicorp/terraform:${TERRAFORM_VERSION}

# Set the working directory in the container
WORKDIR /terraform

# Install dependencies required for Terragrunt
RUN apk add --update --no-cache curl bash

# Install Terragrunt
ARG TERRAGRUNT_VERSION="0.50.7"
RUN curl -Ls https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -o /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt

# Verify installations
RUN terraform --version && terragrunt --version

# Set the entrypoint to Terraform
ENTRYPOINT ["bash"]