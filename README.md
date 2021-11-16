## Table of Contents
* [About the app](#about-the-app)
* [Quick start](#quick-start)
* [Repository structure](#repository-structure)
   * [network-module](#network-module)
   * [cluster-module](#cluster-module)
   * [deploy-module](#deploy-module)
* [FAQ](#faq)
* [License](#license)

## About the app

This repository contains code to deploy an infrastructure using Kubernetes and Helm in GCP service. That code was developed by Thiago Leite <tfmleite (at) gmail (dot) com> as a test to a job position.

The project uses Terraform and Helm tools to create a new infrastructure using Kubernetes in GCP service and deploy an application (Guestbook) using Redis. The Guestbook package created by author contains PHP Guestbook application published at [here](https://kubernetes.io/docs/tutorials/stateless-application/guestbook/). The package has as dependency Redis package. Redis package is hosted on public repository. 

The Kubernetes Dashboard also is deployed to monitor the environment if no need to access GCP console.  

## Quick start
**Command line tools requirements:** Before start you need to check if you have the follow installed tools and they could be used from command line interface (CLI) of your operating system: 
 * [gcloud](https://cloud.google.com/sdk/gcloud/)
 * [terraform](https://www.terraform.io)

```bash
$ which terraform
$ which gcloud
```

**Prerequisite:** make sure you're authenticated to GCP via gcloud command line tool using either _default application credentials_ or _service account_ with needed access. You need to download a JSON credentials file from GCP console with authorization access to deploy the new infrastructure into a project. This file need to be inside `my-cluster` folder from the project code. 

it is also needed a .kube directory inside user home dir. That directory structure could be also created during Terraform process if you don't have yet. Terraform script is programmed to continue on fail while it try to create it but that directory is neede anyway. If you're running the Terraform script on Google Shell that situation is not a problem and the installation process could continue.

Check **terraform.tfvars** file inside `my-cluster` folder to see what variables you need to define before you can use terraform to create a cluster and deploy the application. By default the file don't exist. You could create it using the follow command:

```bash
$ cd my-cluster && cp terraform.tfvars.example terrraform.tfvars
```

Once the required variables are defined and gcloud already have access to your project, you could the commands below to initialize Terraform tool and start the deployment task to a new environment: 

```bash
$ terraform init && terraform apply
```

After the Terraform and Helm deploy the application to your new Kubernetes cluster, after some minutes (˜5 min), open your browser and access the followig URL to check Guestbook (or other name if you change the default value) application using Redis up and running in GCP cloud service:

[http://cloud.thiagofmleite.com](http://cloud.thiagofmleite.com)

If you want to see additional things about the new infrastructure and application you also can access [http://monitor.cloud.thiagofmleite.com](http://monitor.cloud.thiagofmleite.com) to access Kubernetes Dashboard. Considering it is only a test the dashboard doesn't requires credentials to access. 

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
This folder contains all definitions to K8s cluster like GCP APIs needed, how to generate configuration files to access using kubectl tool, initializing Kubernetes nodes and so on. It was placed as a module to improve better code orgazanition.

### deploy-module
The folder contains all configurations to deploy the Guestbook application (and dependencies) after network and cluster provisioning tasks. The deployment includes a Helm resource responsible to download the helm package (including Redis package) and install it to cluster. The generated helm package itself is hosted at original Github page by [Thiago Leite](https://github.com/thigu/job-test/tree/main/my-cluster/k8s-config/charts). The deploy module also creates an 'ingress' to created to allow external access to the application.

## faq
1. After initialize Terraform and start the "apply" subcommand, some minutes after the process begin it stops with a timeout error (dial tcp tieout). If you have any Internet connectivity issue during the process that error could happen. It is not really a problem. Terraform can start where it stoped before. So run again the command below to finish the process:

```bash
$ terraform apply
```

2. The create process has finished but the URL [http://cloud.thiagofmleite.com](http://cloud.thiagofmleite.com) returns HTTP 404 error. Considering that process includes 'ingress' service it requires some time to be done. Wait for 5 minutes and try again.

3. Terraform freezes during `apply` procedures. Considering Terraform depends of a lot of other resources (i.e Internet connection, GCP service, etwork latency, chart repositories...) the apply or destroy process could freezes. If it happen you need to use Ctrl+C hotkeys and just try again. 

## license

All repository is license under [Apache License 2.0](https://github.com/thigu/job-test/blob/main/LICENSE). 
