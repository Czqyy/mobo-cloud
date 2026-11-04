# Multi-objective Optimisation (MOBO) of Cloud Infrastructure
## Running Web Server with Uvicorn
```bash
uvicorn workload.main:app --host 0.0.0.0 --port 8000 --reload
```

## Build Docker Container
From working directory, build a Docker image:
```bash
docker build -t <image-name> .
```
Start the container:
```bash
docker run -d --name <container-name> --restart=always -p 8000:8000 <image-name>
```

## Terraform AWS Provision

### Prerequisite
Manually setup a running EC2 instance for desired workload and snapshot into an AMI and set `ami_id=<AMI ID>`. Creating this AMI makes it faster to directly get an EC2 instance up and running (as Docker container). 

### Setup ASG
```bash
cd ./terraform

# Initialise and download AWS provider plugins
terraform init

# Review resources to create
terraform plan

# Deploy infrastructure
terraform apply -auto-approve
```

### Teardown
```bash
# Teardown every resources created
terraform destroy -auto-approve
```
