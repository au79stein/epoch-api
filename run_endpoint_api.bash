#!/usr/bin/env bash
set +x

NAMESPACE="epoch-api"

create_namespace() {
  NS=$1
  kubectl create namespace ${NS}
}

set_default_namespace() {
  NS=$1
  kubectl  config set-context --current --namespace=${NS}
}

get_pods() {
  kubectl get pods -o wide
  echo
}

run_cmd() {
  CMDF=$2
  CMD=$1

  kubectl ${CMD} -f ${CMDF}
  echo
}

get_svc() {
  SVCN=$1
  kubectl get svc ${SVCN}
  echo
}

desc_svc() {
  SVCN=$1

  kubectl describe svc ${SVCN}
  echo
}

get_endpoint() {
  local result
  result=$(kubectl get svc epoch-api-lb | awk '/^epoch-api-lb/ {print $4}' | awk -F"," '{print $1}')
  echo "$result"
}

###

create_namespace ${NAMESPACE}
set_default_namespace ${NAMESPACE}
get_pods
run_cmd apply epoch-api-deployment.yaml
get_pods
run_cmd apply epoch-api-lb.yaml
get_svc epoch-api-lb
desc_svc epoch-api-lb
echo "sleeping, waiting for loadbalancer"
echo "should be untimed waiting for state to change from pending"
sleep 15
my_endpoint="$(get_endpoint)"
echo "endpoint is: $my_endpoint"
echo "curl command is curl ${my_endpoint}:9000" 
curl ${my_endpoint}:9000
