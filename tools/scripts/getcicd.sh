#!/bin/bash
# Update these to match your environment
export SERVICE_ACCOUNT_NAME=argo-sa
export NAMESPACE=default
export NEW_CONTEXT=argo-sa

./getkube.sh $SERVICE_ACCOUNT_NAME $NAMESPACE $NEW_CONTEXT
