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

## Secret to store the Credentials of ArgoCD-Application-Repository 

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

## Creating ArgoCD Application

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

## Creating a Secret to store the Credentials of Private Docker Registry 

```
kubectl create secret docker-registry SECRET-NAME   --docker-server=registry.gitlab.com  --docker-username=GITLAB-USERNAME   --docker-password="ACCESS-TOKEN" -n YOUR-NAMESPACE
```

## Contributing
I will be very glad to accept any contribution which will take this whole project one step further.
