ytt -f values.yaml \
    -f manifests/ \
     -f /home/jeff/config/certs/mkcert_development_CA_146457396271771716678352258984121938072.pem \
    -v docker_repository="harbor.ellin.net/build-service/build-service" \
    -v docker_username="admin" \
    -v docker_password="Harbor12345" \
    | kbld -f images-relocated.lock -f- \
    | kapp deploy -a tanzu-build-service -f- -y