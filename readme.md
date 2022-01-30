# Argo Workflows: Automate, schedule, and manage complicated K8s tasks

Demo environment, using k3d and ArgoCD, to deploy Argo Workflows and create sample tasks.

## How to

```bash
# Clone the repo
git clone https://github.com/J0hn-B/argo_workflows_demo.git && cd "$(basename "$_" .git)"
```

```bash
# Create a k3d cluster, install and configure ArgoCD and Argo Workflows.
make apply

# Clean up
make destroy

# Lint code
make code_lint

# Check makefile for more commands ;-)
```

### Prerequisites

k3d, make

## Usage

**`$ make apply`**

> Be sure to wait until the deployment has completed before continuing.

![image](https://user-images.githubusercontent.com/40946247/151705732-029009f5-0da8-4bbb-b2ab-1797b60399f5.png)

## Submit a workflow

> Download the latest [Argo CLI](https://github.com/argoproj/argo-workflows/releases) first.

```bash
# Submit hello world workflow
argo submit -n argo --watch argo-workflows/workflows/hello-world.yaml

# Submit a k8s resource workflow. Check k8s/clusters/base and k8s/clusters/overlays/dev for information related to the k8s Service Account used by Argo Workflows.
argo submit -n argo --watch argo-workflows/workflows/k8s-operations.yaml

# Submit a multi-step workflow
argo submit -n argo --watch argo-workflows/workflows/multi-step.yaml
```

Access the ArgoCD dashboard.

Access the Argo Workflows dashboard.
