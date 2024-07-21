# DevSecOps On Netflix-Clone Application

![Diagram](https://github.com/Helion55/DevSecOps-on-Netflix-Clone/blob/main/project-diagram.jpg?raw=true)

## About

DevSecOps practices applied on Netflix-Clone application build with NodeJS and Deployed on 2 Kuberntes Clusters.
One is Running on Azure Kuberntes Service (AKS), and other on Local Virtual Machine. Goal is to Setup the AKS with Terraform and Local Virtual Machine with Ansible. Which are one of the best Infrastructure as a Code Technologies right now. Let me introduce with the whole tech-stack now for the DevOps or DevSecOps Part.

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

GitlabCI and ArgoCD is used for the CI/CD part, Trivy is covering the security part, On Kubernetes the application will run, Azure is providing the cloud Infrastructure, Prometheus and Grafana is completing the Monitoring. This way a whole DevSecOps Project is getting Complete. I am using Azure kanban Boards to keep track of my Progress😉.

## Steps to follow from testing to deployment
- GitLab Section
  1. Local Runner installation
  2. Creating Pipeline file
  3. Testing the application
  4. Building Docker Image
  5. Scanning the Image
  6. Pushing the Image

- Kubernetes Section
  1. Cluster Setup
  2. ArgoCD Installation
  3. ArgoCD Configuration
  4. Repository Connection
  5. Deployment of Application

## Gitlab Section

### 1. Local Runner Installation
Runners are the Machines where our testing script will be executd. Gitlab provides its own runner which uses Ruby Image by default. As our application need Node and Docker image both and in Local Machine having them already, its very convinient to use the Local Machine as Runner. 
- Install the GitLab Runner Application from this url:https://docs.gitlab.com/runner/install/linux-manually.html .
- Now on GitLab go to Settings->CI/CD->Runners->Create Runner and execute this commands on the machine where Runner is Installed
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
As local machine have npm already installed this commands are typed to test and fix the code.
```
npm install
npm audit fix
```
### 4. Building Docker Image
A docker argument should passed during build, the API Key of the The Movie Data Base Website https://www.themoviedb.org/ . Create a account and create a your API Key in TMDB. Copy and paste the API Key on docker build command
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

## Contributing
I will be very glad to accept any contribution which will take this whole project one step further.
