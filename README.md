# DevSecOps On Netflix-Clone Application

![Diagram](https://github.com/Helion55/DevSecOps-on-Netflix-Clone/blob/main/project-diagram.jpg?raw=true)

## Project Overview

A Netflix-Clone application Build-Test and Deployed using DevSecOps practices. I have created 2 Kubernetes clusters. One on Vagrant machine using Ansible and other on Azure(AKS) using Terraform. The application was build and containerized form a pipeline build on GitLabCI and then Deployed on the clusters using ArgoCD. Container image was created from Docker and scanned with Trivy. Helm was used for installing ArgoCD, Prometheus and Grafana. Prometheus is fetching cluster health matrics and Grafana is showing this information on a Dashboad. To do the project follow the steps below ...

### Tech-Stack

1. GitLab 
   - Implementing the Pipeline of Test and Build.

2. Docker 
   - Containerizing the applications.

3. Trivy
   - Scanning the Docker Images.

3. Kuberntes
   - Running the whole applications on.

4. ArgoCD 
   - Implementing the Continuous Deployment.

5. Terraform
   - Provisioning the AKS on Azure.

6. Ansible 
   - Installing Kubernetes and Launching the application on Local Machine.

7. Helm
   - Helm Charts are used for the Deployment and Service files for the Cluster.

8. Prometheus
   - For scrapping the cluster resources data.

9. Grafana
   - Visualizing the Cluster information scrapped by Prometheus.

## Steps to follow from testing to deployment
### GitLab Section
  1. Local Runner installation
  2. Creating Pipeline file
  3. Testing the application
  4. Building Docker Image
  5. Scanning the Image
  6. Pushing the Image

### Ansible Section
  1. Installing Ansible
  2. Vagrant Installation
  3. Configuring Ansible
  4. Executing the Playbook

### Terraform Section
  1. Terraform Installation
  2. Azure CLI Setup
  3. Modifying Terraform Variables
  4. Applying the Terraform files

### Monitoring Section
  1. Installing Prometheus and Grafana
  2. Accessing the Applications
  3. Connecting Grafana to Prometheus
  4. Creating the Dashboard

### Kubernetes Section
  1. Cluster Setup
  2. ArgoCD Installation
  3. ArgoCD Configuration
  4. Repository Connection
  5. Deployment of Application


## Gitlab Section

### 1. Local Runner Installation

Runners are the Machines where our testing script will be executd. Gitlab provides its own runner which uses Ruby Image by default. As our application need Node and Docker image both and in Local Machine having them already, its very convinient to use the Local Machine as Runner. 

- Install the GitLab Runner Application from this url:https://docs.gitlab.com/runner/install/linux-manually.html .

- Now on GitLab go to Settings->CI/CD->Runners->Create Runner and executing this commands on the machine where Runner is Installed
```
gitlab-runner register  --url https://gitlab.com  --token Your-Runner-Token
```
To run the Runner manually type
```
gitlab-runner run
```
Give a tag for your runner, this tag will be used in the pipeline script. Now you are ready to execute your pipeline script on Local Runner.

### 2. Creating Pipeline file
On root of repository create a file named ```.gitlab-ci.yml``` . This is the default name GitLab search for pipeline file.

### 3. Testing the application
As local machine have npm already installed type this commands to test and fix the code.
```
npm install
npm audit fix
```
### 4. Building Docker Image
A docker argument should passed during build, the API Key of the The Movie Data Base Website https://www.themoviedb.org/ . Create a account and create a API Key in The Movie Database website. Copy and paste the API Key on docker build command
```
  docker build --build-arg TMDB_V3_API_KEY=TMDB-WEBSITE-API-KEY -t $CI_REGISTRY_IMAGE/YOUR-IMAGE-NAME:YOUR-IMAGE-VERSION .
```

### 5. Scanning the Image
Trivy is used to scan any vulnerabilty of the image. To install trivy follow this url https://aquasecurity.github.io/trivy/v0.31.3/getting-started/installation/ .

After installing Trivy run this to scan the image,
```
docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image $CI_REGISTRY_IMAGE/YOUR-IMAGE-NAME:YOUR-IMAGE-VERSION
```

### 6. Pushing the Image
Images will be stored in GitLab Registry. Follow this commands,
```
docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
```
```
docker push $CI_REGISTRY_IMAGE/YOUR-IMAGE-NAME:YOUR-IMAGE-VERSION
```


## Ansible Section
As Infrastructure configuration is a tedious work if configuring multiple systems and installing multiple tools by doing SSH, Ansible gives you the power to do this in seconds. It uses SSH to connect to the machines and then execute your commands you specified in file called Playbook. Ansible has Module for almost every tool you use, which is more flexible instead of simple shell commands. 
An Ansible Playbook is created to install the tools and dependencies to run our application on Vagrant machine. 
Docker, Minikube, Kubectl and other tools are installed using the Ansible Playboook.

### 1. Installing Ansible
Ansible can be downloaded using linux package managers or Python, Here Python is used.
Execute these commands...

```
python3 -m pip install --user ansible
```
to verify execute,
```
ansible --version
```
### 2. Vagrant Installation
Vagrant is a Virtual machine creater and manager, which sits perfectly between Docker and Traditional Hypervisor System. It uses a vagrant file to create a VM as our need. VirtualBox is used to run the the VM.

Install Vagrant from https://developer.hashicorp.com/vagrant/install
Install VirtualBox from https://www.virtualbox.org/wiki/Downloads

Use the Vagrantfile above to create the VM.
use command ``` vagrant up``` to start the virtual machine, get the IP of the machine by accessing the machine using ``` vagrant ssh``` command.

### 3. Configuring Ansible
Create a ssh-key pair and connect with the VM. Paste your VM's IP in the ansible inventory file, many remote systems can be groupd together in inventory file. Ansible.conf file could be created to configure Ansible for this Playbook execution. Now execute ``` ansible all -i inventory -m ping ``` to verify a successful connection. If SSH is done previously from your system the saved fingerprints will be used to verify and public key to connect with the system.

### 4. Executing the Playbook
Ansible comes with module for almost every task, now ping is on of those module and -m flag is the module. If every task is completed on by one this it will same as executing shell commands. So Playbook is file where you will specify every tasks you want to do with Ansible and execute that once, it apply all of them automatically. Ansible compares the state you want vs what is the current state then changes the state as needed.
To execute a Playbook use this command...

``` ansible-playbook PLAYBOOK-NAME.yaml -i inventory``` 

You can use ```-vvv```or ```-vv``` for descriptive output.


## Terraform Section
Ansible was configuring the infrastructure but to provision it Terraform is used. Terraform have Providers for every infrastructure you want to provision, including all cloud services, kuberntes and minikube. Providers helps Terraform to connect with the technology and apply the terraform files. Infrastructure as Code is the best way create and manage the infrastructure. You can any time apply the files to create, modify or destroy it. Precise to store infrastructure information, contributing to the code as needed, and can be shared also in form of files.

### 1. Terraform Installation
Terraform can be installed from https://developer.hashicorp.com/terraform/install
To check installation type ```terraform --version```

### 2. Azure CLI Setup
Azure CLI is needed to apply Terraform files, and it also have the authentication rights to connect with Azure. To install it https://learn.microsoft.com/en-us/cli/azure/install-azure-cli foloow this link.

### 3. Modifying Terraform Variables
The main.tf file contains the resources to be created. Provider gives you the Resources access of the infrastructure. Like, deployment or service components of Kubernetes, Azure components like VM or Blob storage or AKS. This resource definition are provided on Modules folder to arrange them. 
Here we are creating 3 types of resources...
1. Key Vault
2. Service Principle
3. Azure Kubernetes Service

Terraform varibles are usesd to give values as per our needs. Give resource group name, location, key vault name, service principle name.

### 4. Applying the Terraform files

First run ``` terraform init ``` command to install the providers.
Then run ``` terraform plan ``` to see waht Terraform will do on Azure.
Apply the terraform files by ``` terraform apply ``` command, it will create the infrastructure as defined int he files.

### Monitoring Section
Monitoring the whole cluster Prometheus and Grafana is used. 
Prometheus will scrape the matrics of the cluster, it uses PromQL for it, store the data in its own database. Prometheus have its endpoints from where data is sent to its database. It can be configured to which set of metrics you want to fetch, specify different clusters or endpoints also.
This metrics data is hard to visualise for that purpose Grafana is connected with prometheus which creates dashboard to visualize this data.

### 1. Installing Prometheus and Grafana
 
Helm is used to install both of them in the cluster. It will create Deployment, Service components of them which helps to access the application on that cluster itself. To create them use this commands...
``` helm repo add prometheus-community https://prometheus-community.github.io/helm-charts ``` this will add Helm repo Prometheus to your system.
update your repo by executing ``` helm repo update ```.
To install the application ``` helm install prometheus prometheus-community/prometheus ``` this command should be executed.

To install Grafana follow the same steps..
```helm repo add grafana https://grafana.github.io/helm-charts ```

``` helm repo update```

``` helm install grafana grafana/grafana ```

### 2. Accessing the Applications
To access these Application you have to expose those services. After the installaton you will get the Grafana Password from a secret created in the cluster, it will show after helm install command.

Exposing the applicaion services ...

Grafana service ``` kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-ext ```

Prometheus service ``` kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext ```

Find minikube ip using ``` minikube ip``` command. paste the ip amd port number from the exposed service in the browser.
Get the Grafana Password from the secret and use it to login in grafana, username=admin

### 3. Connecting Grafana to Prometheus
Paste the Prometheus application IP on Grafana connecting with Prometheus Section.

### 4. Creating the Dashboard
To create a dashboard use a template-id 3662 to create a dashboard.

## Kubernetes Section

### 1. Cluster Overview
The cluster will have 2 Namespace. One for ArgoCD and one for the Application, this will create a clutter free environment. A Seperate Repository is created for ArgoCD, from where the Yaml manifests will be fetched and deployed on application Namespace.

### 2. ArgoCD Installation
ArgoCD can installed from this url,
https://argo-cd.readthedocs.io/en/stable/getting_started/

After ArgoCD is installed and accessed from browser, it can configured using UI. But here as private repository is used, Kubernetes Secrets should be created.

### 3. ArgoCD Configuration
- Private Repository need authorization to be accessed. Here a Kubernetes Secret component is created on ArgoCD namespace to access the Yaml manifests stored in Private Repo. Here it is,
```yaml
apiVersion: v1
kind: Secret
metadata:
 name: argocd-repo
 namespace: argocd
 labels:
  argocd.argoproj.io/secret-type: repository
stringData:
 type: git
 url: REPOSITORY-URL
 username: ACCESS TOKEN NAME
 password: ACCESS TOKEN
```
Now use command ``` kubectl apply ``` on argocd namespace to create this Secret.

- ArgoCD creates a application component on its namespace which fetches the Yaml Manifests and create Deployments. To create this application this apply this manifest,

``` yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: APPLICATION NAME
  namespace: argocd
spec:
  project: default
  source:
    repoURL: REPOSITORY-URL
    targetRevision: HEAD
    path: ANY FOLDER OF THE YAML MANIFESTS
  destination: 
    server: https://kubernetes.default.svc
    namespace: YOUR-NAMESPACE
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    automated:
      selfHeal: true
      prune: true
```

### 4. Repository Connection
Another secret is to be created in the namespace(YOUR-NAMESPACE) where our Project Application(Netflix) will run. This Secret is created to pull the Docker Image from Private Docker Registry. It stores the Docker Credentials.
Create this by executing this command,
```
kubectl create secret docker-registry SECRET-NAME   --docker-server=registry.gitlab.com  --docker-username=GITLAB-USERNAME   --docker-password="ACCESS-TOKEN" -n YOUR-NAMESPACE
```
### 5. Deployment of Application
Refresh the Application created by ArgoCD or modify any repository argument if Yaml Menifests are not fetched. When the pods creation is completed access the application by first viewing the service ``` kubectl get svc -n APPLICATION-NAMESPACE``` and then exposing the service by ```minikube service SERVICE-NAME --url``` .

The Netflix Application is ready...🚀

This way a whole DevSecOps Project is getting Complete. I have used Azure kanban Boards to keep track of my Progress😉.

## Contributing
I will be very glad to accept any contribution which will take this whole project one step further.
