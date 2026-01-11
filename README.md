# EKS-Sockshop-DevOps

This repository contains automation and infrastructure code for deploying the **Sock Shop microservices demo (https://github.com/microservices-demo/microservices-demo)** on **AWS Elastic Kubernetes Service (EKS)** with development, staging, and CI/CD support.

The project includes:

- Environment-specific deployment artifacts (`sock-shop-dev`, `sock-shop-staging`)
- Terraform infrastructure to provision networking, EKS cluster, and related resources (`sock-shop-terraform`)

This setup demonstrates best practices for deploying a microservices application on AWS using Infrastructure as Code (IaC), Kubernetes manifests, and CI pipelines.

## Project Structure

- sock-shop-dev # Development environment deployments and configs
- sock-shop-staging # Staging environment deployments and configs
- sock-shop-terraform # Terraform IaC for provisioning AWS infrastructure.

  
## Prerequisites

Before using this repository, you should have:

- AWS account and AWS CLI configured  
- Terraform installed  
- kubectl installed and configured  
- Gitlab repository to use CI/CD pipelines

## Getting Started

1. **Provision infrastructure**  
   ```
   cd sock-shop-terraform
   terraform init
   terraform apply
   ```
2. **Deploy to dev environment**
   
  the dev environment consists of three options:
- docker compose
  ```
  cd sock-shop-dev/docker-compose
  docker compose up -d
  ```
- Kubernetes manifests:
  ```
  cd sock-shop-staging/
  kubectl apply -f kubernetes/manifests/namespace.yaml
  kubectl apply -f kubernetes/manifests/
  ```
- helm chart:
  ```
  kubectl apply -f kubernetes/manifests/namespace.yaml
  helm install sockshop ./sock-shop-helm/ --values ./sock-shop-helm/values.yaml --namespace sock-shop --create-namespace
  ```
Health check and end-to-end tests are implemented in the CI pipeline defined in [.gitlab-ci.yml](./sock-shop-dev/.gitlab-ci.yml).



