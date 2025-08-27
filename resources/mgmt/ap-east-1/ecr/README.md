# Adding a New Container Image Registry

The container image registry created via Infrastructure as Code (IaC) follows this structure:

- The registry is organized by namespace. For example, if the namespace is `backend`, it should be added as follows:

```hcl
repositories = {
    <NAMESPACE> = {
        owner = "<Owner of the Container Image Registry, preferably an email>"
        team = "<Team responsible for the Container Image>"

        immutable = true // image tag immutability, default to MUTABLE.
        scan_on_push = true // whether to enable scan during push image, default to false
        pull_accounts = [] // list of allowed AWS accounts to pull the image, if it is empty it will refer `default_pull_accounts` variable instead.

        resources = {
            <IMAGE_NAME_1> = {}
            <IMAGE_NAME_2> = {}
            <IMAGE_NAME_3> = {}
        }
    }

    "backend" = {
        owner = "engineering@ardikabs.com"
        team = "backend"

        immutable = true
        scan_on_push = true
        pull_accounts = [
            "851725318587",
        ]

        resources = {
            "gateway" = {}
            "monolith-core" = {}
        }

    }
}
```

- Once applied, the container images will be available at: `123456789012.dkr.ecr.ap-east-1.amazonaws.com/<NAMESPACE>/<IMAGE_NAME>`.
- We utilize a centralized ECR approach, meaning all container images will always reside under the `123456789012` AWS account, regardless of the environment.
