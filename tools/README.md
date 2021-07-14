Assumptions,

1. Persitent Volume Provisioning works
2. Extenral LBs work


kubectl create ns cicd

helm install jenkins . -n cicd

kubectl patch svc jenkins -n cicd -p '{"spec": {"type": "LoadBalancer"}}'


kubectl exec --namespace cicd -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo

    QPDRYPe9lIlZUaQoa9XVY8

Create an ssh secret called `ssh` for github

create an secret called pks-cicd with a KUBECONFIG file for the cicd cluster

kubectl create secret generic pks-cicd --from-file=kubeconfig=kpack-deploy-sa -n cicd

Create a new freestyle job
  setup the app seed job

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

PNsWVMrNGLANPHRX


jenkins yaml,  add script utils ( readJosn) and simple webhook trigger