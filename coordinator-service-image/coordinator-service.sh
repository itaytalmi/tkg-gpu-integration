#!/bin/bash

# Script usage function
function usage() {
  echo "Usage: $0 <WORK_DIR> <FFMPEG_IMAGE>"
  echo "For example: $0 /ffmpeg-processing l01-tkgm-harbor.cloudnativeapps.cloud/ffmpeg-supply-chain-gpu-demo/ffmpeg:5.1.2-nvidia2004"
  exit 1
}

# Input validation
if [ $# -ne 2 ]
then
  usage
fi

# Set variables
export WORK_DIR=$1
export FFMPEG_IMAGE=$2

# Validate connectivity to Kubernetes cluster
validate_k8s_cluster_connectivity() {
  if ! output=$(kubectl cluster-info 2>&1); then
    printf '%s\n' "$output" >&2
    exit 1
  fi
  printf 'Validating connectivity to Kubernetes cluster...\n'
  kubectl cluster-info
}

validate_k8s_cluster_connectivity

# Check for files and handle processing by trigerring Kubernetes jobs
echo "Processing files in $WORK_DIR"

while true; do
  for file in $(ls -1 $WORK_DIR | grep -v processed); do
    export FILE_NO_EXT=$(echo $file | cut -d'.' -f1)
    FILE_FIND=$(find "$WORK_DIR" -maxdepth 1 -name "${file}.processed*" -print -quit)

    if [[ -n $FILE_FIND ]]; then
      echo "$file has already been processed"
    else
      export RANDOM_JOB_ID=$RANDOM
      export TARGET_FILE=$file
      echo "Creating Kubernetes job for $file..."
      envsubst < /root/ffmpeg-nvidia-job-template.yaml | kubectl apply -f -
      touch "$WORK_DIR/$TARGET_FILE.processed"
    fi
    sleep 10
  done
done