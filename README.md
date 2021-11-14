## Table of Contents
* [About the app](#about-the-app)
* [Quick start](#quick-start)
* [Repository structure](#repository-structure)
   * [network-module](#network-module)
   * [cluster-module](#cluster-module)
   * [deploy-module](#deploy-module)
* [FAQ](#faq)

## About the app

This repository contains code to deploy an infrastructure using Kubernetes in GCP service. That code was developed to a job test by Thiago Leite. 

The project uses Terraform and Helm tools to create a new infrastrcuture using Kubernetes in GCP service and deploy an application (Guestbook) using Redis. 

## Quick start
**Prerequisite command line tools:** Before start you need to check if you have the follow installed tools and they could be used from command line interface (CLI) of your operating system: 
 * [gcloud](https://cloud.google.com/sdk/gcloud/)
 * [terraform](https://www.terraform.io)

**Prerequisite:** make sure you're authenticated to GCP via gcloud command line tool using either _default application credentials_ or _service account_ with needed access. If you're executing commands to GCP from a remote computer could be necessary to download a JSON credentials file from GCP console.  

Check **terraform.tfvars** file inside `my-cluster` folder to see what variables you need to define before you can use terraform to create a cluster and deploy the application.  

Once the required variables are defined and gcloud already have access to your project, you could the commands below to initialize Terraform tool and start the deployment tasks to a new environment: 
```bash
$ terraform init
$ terraform apply
```

After the Terraform and Helm deploy the application to your new Kubernetes cluster, after some minutes (˜5 min), open your browser and access the followig URL to check Guestbook application using Redis up and running in GCP cloud service:

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

## faq
1. After initialize Terraform and start the "apply" subcommand, the process stops a timeout error. If you have any Internet connectivity problem could happen an error. It is not really a problem. Terraform could continue the creating process where it stoped before. So run again the command below to finish the process:

'''
$ terraform apply
'''
2. The create process has finished but the URL http://cloud.thiagofmleite.com returns HTTP 404 error. Considering that process includes ingress service it requires some time to be done. Wait for 5 minutes and try again. 
