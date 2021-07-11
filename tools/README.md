Assumptions,

1. Persitent Volume Provisioning works
2. Extenral LBs work


kubectl create ns cicd

helm install jenkins . -n cicd

kubectl exec --namespace cicd -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo

    QIjzTw7xFlkLHBkx6TcazD

Create an ssh secret called `ssh` for github

create an secret called pks-cicd with a KUBECONFIG file for the cicd cluster

Create a new freestyle job
  setup the app seed job

