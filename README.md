# EKS-Sockshop-DevOps

This repository contains automation and infrastructure code for deploying the **Sock Shop microservices demo (https://github.com/microservices-demo/microservices-demo)** on **AWS Elastic Kubernetes Service (EKS)** with development, staging, and CI/CD support.

The project includes:

- Environment-specific deployment artifacts (`sock-shop-dev`, `sock-shop-staging`)
- Terraform infrastructure to provision networking, EKS cluster, and related resources (`sock-shop-terraform`)

This setup demonstrates best practices for deploying a microservices application on AWS using Infrastructure as Code (IaC), Kubernetes manifests, and CI pipelines.

## Project Structure

- sock-shop-dev # Development environment deployments and configs
- sock-shop-staging # Staging environment deployments and configs
- sock-shop-terraform # Terraform IaC for provisioning AWS infrastructure
