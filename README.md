Assumptions,

You have a working k8s cluster with the following enabled options:

1. Persistent Volume Provisioning works
2. External LBs work
3. TBS is installed

## create a service account.  This account allows jenkins to create containers in the kubernetes cluster.

Create the Service Account

`kubectl apply -f scripts/rbac.yaml`

Create the kubecontext file using the shell script in the script directory.

`getcicd.sh`

This should leave you with a KUBECONFIG file. `kpack-deploy-sa'


## Jenkins Integration

Install Jenkins with bitnami helm

```
helm repo add bitnami https://charts.bitnami.com/bitnami
```

Download the helm chart ( we need to make a change)

```
helm pull bitnami/jenkins
```

Unzip the helm chart.

```
tar zxvf jenkins-8.0.4.tgz
```

in the `templates/deployment.yaml` add a service account fo the deployment.

```
serviceAccountName: kpack-deploy-sa
```

apply the helm chart from the top level jenkins folder

```
helm install jenkins .
```

Path the jenkins install to get an external load balancer.

```
kubectl patch svc jenkins -p '{"spec": {"type": "LoadBalancer"}}'
```

Get the jenkins credentials

```
  echo Password: $(kubectl get secret --namespace default jenkins -o jsonpath="{.data.jenkins-password}" | base64 --decode)
```

# Configure Jenkins 

Download the following plugins

1. Kubernetes
2. environment inject
3. Generic webhook triggers
4. ssh agent
5. Job DSL
6. Utility Step Plugins

## Configure Kubernetes Plugin

Manage-Jenkins->Nodes and Clouds->Configure Clouds->

Kubernetes URL:  https://kubernetes.default

Kubernetes Namspace: default

Websocket: checked 

Jenkins URL:  http://jenkins:80

### Add a GIT credential

add your private key to access github as an SSH credential


### Configure service account secret.

Build container requires k8s access for kpack.

```
kubectl create secret generic jenkins-sa --from-file=kubeconfig=kpack-deploy-sa 
```

### Configure seed job

Create a new Freestyle job,   give the git url of the repository containing the
seed job.  Under Build steps choose a Process Job DSLs step.

Look for scripts on filesystem. 

```
ci/jenkins/*.groovy
```

### Run the job

The job may fail due to unapproved scripts.

Manage-Jenkins->In-Process-Script-Approval.

  *  Approve all the scripts,  there should be 3.
  *  Rerun the job.

## Install Argo.

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

Get the Password

```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## Harbor

Configure webhook

```
http://<jenkinsip>/generic-webhook-trigger/invoke?token=stage-rebuild
```

### OTHER STUFF FOR POSTERITY

(⎈ |playground:default)jeff@ubuntu-1:~/tbs$ kbld relocate -f images.lock --lock-output images-relocated.lock --repository reg.ellin.net/build-service/build-service

ytt -f values.yaml \
    -f manifests/ \
    -f /home/jeff/certs/mkcert_development_CA_146457396271771716678352258984121938072.pem \
    -v docker_repository="reg.ellin.net/build-service/build-service" \
    -v docker_username="admin>" \
    -v docker_password="******" \
    | kbld -f images-relocated.lock -f- \
    | kapp deploy -a tanzu-build-service -f- -y

    ytt -f /tmp/bundle/values.yaml \
      -f /tmp/bundle/config/ \
      -f /home/jeff/certs/mkcert_development_CA_146457396271771716678352258984121938072.pem \
      -v docker_repository="reg.ellin.net/build-service/build-service" \
      -v docker_username="admin" \
      -v docker_password="******" \
      | kbld -f /tmp/bundle/.imgpkg/images.yml -f- \
      | kapp deploy -a tanzu-build-service -f- -y





