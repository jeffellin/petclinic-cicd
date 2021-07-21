FROM docker:dind

ENV KUBE_VERSION 1.20.4
ENV HELM_VERSION 3.5.3
ENV KP_VERSION 0.2.0
RUN apk add --no-cache ca-certificates bash git openssh curl jq bind-tools subversion git-svn \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget -q https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && chmod g+rwx /root \
    && mkdir /config \
    && chmod g+rwx /config \
    && helm repo add "stable" "https://charts.helm.sh/stable" --force-update

RUN wget https://github.com/vmware-tanzu/kpack-cli/releases/download/v${KP_VERSION}/kp-linux-${KP_VERSION}
RUN mv kp-linux-${KP_VERSION} /usr/local/bin/kp
RUN chmod a+x /usr/local/bin/kp

RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
RUN mv kustomize /usr/local/bin

ADD ca.crt  /usr/local/share/ca-certificates
RUN update-ca-certificates
WORKDIR /config

CMD bash
