Assumptions,

1. Persitent Volume Provisioning works
2. Extenral LBs work


(⎈ |playground:default)jeff@ubuntu-1:~/tbs$ kbld relocate -f images.lock --lock-output images-relocated.lock --repository reg.ellin.net/build-service/build-service

ytt -f values.yaml \
    -f manifests/ \
    -f /home/jeff/certs/mkcert_development_CA_146457396271771716678352258984121938072.pem \
    -v docker_repository="reg.ellin.net/build-service/build-service" \
    -v docker_username="admin>" \
    -v docker_password="Admin12345" \
    | kbld -f images-relocated.lock -f- \
    | kapp deploy -a tanzu-build-service -f- -y

    ytt -f /tmp/bundle/values.yaml \
      -f /tmp/bundle/config/ \
      -f /home/jeff/certs/mkcert_development_CA_146457396271771716678352258984121938072.pem \
      -v docker_repository="reg.ellin.net/build-service/build-service" \
      -v docker_username="admin" \
      -v docker_password="Admin12345" \
      | kbld -f /tmp/bundle/.imgpkg/images.yml -f- \
      | kapp deploy -a tanzu-build-service -f- -y

kubectl create ns cicd

helm install jenkins . -n cicd

k

kubectl exec --namespace cicd -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo

    FpL0qeEsDs

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