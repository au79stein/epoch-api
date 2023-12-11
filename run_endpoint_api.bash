#!/usr/bin/env bash

NAMESPACE="epoch-api"

create_namespace() {
  NS=$1
  kubectl create namespace${NS}
  
set_default_namespace() {
  NS=$1
  kubectl  config set-context --current --namespace=${NS}
}

get_pods() {
  kubectl get pods -o wide
}

run_cmd() {
  CMDF=$2
  CMD=$1

  kubectl ${CMD} -f ${CMDF}
}

get_svc() {
  SVCN=$1
  kubectl get svc ${SVCN}
}

desc_svc() {
  SVCN=$1

  kubect describe svc ${SVCN}
}

###

create_namespace ${NAMESPACE}
set_default_namespace ${NAMESPACE}
getpods
run_cmd apply epoch-api-deployment.yaml
getpods
run_cmd apply epoch-api-lb.yaml
get_svc epoch-api-lb
desc_svc epoch-api-lb
