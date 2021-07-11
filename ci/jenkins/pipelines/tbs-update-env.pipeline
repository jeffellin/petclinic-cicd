pipeline {

    agent {
        kubernetes {
            defaultContainer 'jnlp'
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
     app.kubernetes.io/name: jenkins-build
     app.kubernetes.io/component: jenkins-build
     app.kubernetes.io/version: "1"
spec:
  volumes:
   - name: secret-volume
     secret:
       secretName: pks-cicd
  hostAliases:
  - ip: 192.168.1.154
    hostnames:
    - "small.pks.ellin.net"
  - ip: 192.168.1.80
    hostnames:
    - "harbor.ellin.net"
  containers:
  - name: k8s
    image: harbor.ellin.net/library/docker-build
    command:
    - sleep
    env:
      - name: KUBECONFIG
        value: "/tmp/config/jenkins-sa"
    volumeMounts:
    - name: secret-volume
      readOnly: true
      mountPath: "/tmp/config"
    args:
    - infinity
"""
        }
    }

    environment {
        ENV_NAME="${env.ENV_NAME}"
    }

    stages {



        stage('Update TBS for Environment'){
            steps {
                container('k8s'){
                    dir("gitops"){
                        git(
                            poll: true,
                            changelog: true,
                            branch: "${ENV_NAME}",
                            credentialsId: "git-jenkins",
                            url: "git@github.com:jeffellin/spring-petclinic-gitops.git"
                        )
                        script{
                        def props = readJSON file: 'tbs/tbs-builds.json'
                        create_images(props.builds)
                    }
           
                    }
                }
            }
        }
        
}
}
def create_images(list) {
    for (int i = 0; i < list.size(); i++) {
        sh """#!/bin/sh -ex
                    printenv
                    kp image save ${list[i].name}-${ENV_NAME} \
                        --git git@github.com:jeffellin/${list[i].name}.git \
                        -t harbor.ellin.net/${ENV_NAME}/${list[i].name} \
                        --env BP_GRADLE_BUILD_ARGUMENTS='--no-daemon build' \
                        --git-revision ${list[i].commit} -w
                """
    }
}
