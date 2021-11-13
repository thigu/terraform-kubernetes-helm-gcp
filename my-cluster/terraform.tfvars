project_id = "dxxr-331522"
region = "europe-west1"

credentials_file         = "credentials.json"

name = "my-cluster2"
description = "Test cluster to showcase CI/CD with k8s, Gitlab CI, and Helm"
zone = "europe-west1-b"
initial_node_count = 4 # number of nodes in the cluster

ntw_name = "my-cluster-network2" # VPC network name which will be created
