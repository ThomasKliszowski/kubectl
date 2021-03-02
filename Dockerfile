FROM alpine

LABEL version="1.0.0"
LABEL name="kubectl"
LABEL repository="http://github.com/steebchen/kubectl"
LABEL homepage="http://github.com/steebchen/kubectl"

LABEL maintainer="Luca Steeb <contact@luca-steeb.com>"
LABEL com.github.actions.name="Kubernetes CLI - kubectl"
LABEL com.github.actions.description="Runs kubectl. The config can be provided with the parameter with.kube_config_data."
LABEL com.github.actions.icon="terminal"
LABEL com.github.actions.color="blue"

COPY LICENSE README.md /
COPY entrypoint.sh /entrypoint.sh

RUN apk add curl

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
