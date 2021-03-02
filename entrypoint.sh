#!/bin/sh

main() {
  # Migrate legacy use of KUBE_CONFIG_DATA
  if [ -z "$INPUT_KUBE_CONFIG_DATA" ] ; then INPUT_KUBE_CONFIG_DATA=$KUBE_CONFIG_DATA ; fi
  sanitize "$INPUT_KUBE_CONFIG_DATA" "kube_config_data"

  if [ -z "$INPUT_KUBECTL_VERSION" ]
  then
    if [ -z "$KUBECTL_VERSION" ]
    then
      # Kubectl version defaults to latest
      INPUT_KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
    else
      # Migrate legacy use of KUBECTL_VERSION
      INPUT_KUBECTL_VERSION=$KUBECTL_VERSION
    fi
  fi

  # Set kube config
  echo -n "$INPUT_KUBE_CONFIG_DATA" | base64 -d > /tmp/config
  export KUBECONFIG=/tmp/config

  # Download kubectl executable
  echo "Use kubectl $INPUT_KUBECTL_VERSION"
  curl -LO https://storage.googleapis.com/kubernetes-release/release/$INPUT_KUBECTL_VERSION/bin/linux/amd64/kubectl
  chmod +x kubectl
  mv kubectl /usr/local/bin

  sh -c "kubectl $INPUT_COMMAND"
}

sanitize() {
  if [ -z "${1}" ]; then
    >&2 echo "Unable to find the ${2}. Did you set with.${2}?"
    exit 1
  fi
}

main
