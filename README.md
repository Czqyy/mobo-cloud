# Multi-objective Optimisation (MOBO) of Cloud Infrastructure
## Running Web Server with Uvicorn
```bash
uvicorn workload.main:app --host 0.0.0.0 --port 8000 --reload
```
## Terraform AWS Provision

### Prerequisite
Manually setup a running EC2 instance for desired workload and snapshot into an AMI and set `ami_id=<AMI ID>` in `./terraform/terraform.tfvars`. Creating this AMI makes it faster to directly get an EC2 instance up and running (as Docker container). 

#### Snapshot AMI
While SSH'ed into a fresh EC2 instance:
```bash
# Install docker and git
sudo dnf install -y docker git

# Grant root permissions to docker
sudo usermod -aG docker "$USER"

# Configure docker to start on boot
sudo systemctl enable --now docker

# Pull repository
git clone https://github.com/Czqyy/mobo-cloud.git
cd mobo-cloud

# Build docker image
docker build -t <image-name> .

# Run docker container
docker run -d --name <container-name> --restart=always -p 8000:8000 <image-name>

# Check if server is up and running
curl -i http://127.0.0.1:8000/health
```

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
# Terminate instances without tearing down all resources
terraform plan -var='asg_min_size=0' -var='asg_max_size=0'
terraform apply -var='asg_min_size=0' -var='asg_max_size=0'

# Teardown every resources created
terraform destroy -auto-approve
```
