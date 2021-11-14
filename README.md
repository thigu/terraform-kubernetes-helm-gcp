## Table of Contents
* [About the app](#about-the-app)
* [Quick start](#quick-start)
* [Repository structure](#repository-structure)
   * [network-module](#network-module)
   * [cluster-module](#cluster-module)
   * [deploy-module](#deploy-module)

## About the app

This repository contains code to deploy an infrastructure using Kubernetes in GCP service. That code was developed to a job test by Thiago Leite. 

The project uses Terraform and Helm tools to create a new infrastrcuture using Kubernetes in GCP service and deploy an application (Guestbook) using Redis. 

## Quick start
**Prerequisite:** make sure you're authenticated to GCP via [gcloud](https://cloud.google.com/sdk/gcloud/) command line tool using either _default application credentials_ or _service account_ with proper access.

Check **terraform.tfvars** file inside `my-cluster` folder to see what variables you need to define before you can use terraform to create a cluster and deploy the application.

Once the required variables are defined and credentials file, use the commands below to execute all jobs needed to deploy the new environment: 
```bash
$ terraform init
$ terraform apply
```

After the Terraform and Helm create an deploy the application, open your browser and access the followig URL:

```
http://www.cloud.thiagofmleite.com
```


## Repository structure
```bash
├── LICENSE
├── README.md
├── chart-sources
│   └── guestbook
│       ├── Chart.lock
│       ├── Chart.yaml
│       ├── charts
│       │   └── redis-10.5.14.tgz
│       ├── templates
│       │   ├── NOTES.txt
│       │   ├── _helpers.tpl
│       │   ├── deployment.yaml
│       │   ├── hpa.yaml
│       │   ├── ingress.yaml
│       │   ├── service.yaml
│       │   └── serviceaccount.yaml
│       └── values.yaml
├── my-cluster
│   ├── credentials.json
│   ├── dns.tf
│   ├── firewall.tf
│   ├── k8s-config
│   │   └── charts
│   │       └── index.yaml
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── static-ips.tf
│   ├── terraform.tfvars
│   └── variables.tf
└── terraform-modules
    ├── cluster
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── deploy
    │   ├── main.tf
    │   ├── resource.tf
    │   └── variables.tf
    ├── firewall
    │   └── ingress-allow
    │       ├── main.tf
    │       └── variables.tf
    └── vpc
        ├── main.tf
        ├── outputs.tf
        └── variables.tf

```

### network-module
The folder contains Terraform definition to network elements like VPC network. It was placed alone to be create before any other element using Terraform. 


### cluster-module
This folder contains all definitions to K8s cluster. 

### deploy-module
The folder contains all configurations to deploy the Guestbook application (and dependencies) after network and cluster provisioning tasks. The deployment includes a Helm resource responsible to download the helm package (including Redis package) and install it to cluster. The deploy module also creates an ingress to created to allow external access to the application. 

