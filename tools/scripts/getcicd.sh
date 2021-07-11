#!/bin/bash
# Update these to match your environment
export SERVICE_ACCOUNT_NAME=kpack-deploy-sa
export NAMESPACE=default
export NEW_CONTEXT=kpack-deploy-sa

./getkube.sh $SERVICE_ACCOUNT_NAME $NAMESPACE $NEW_CONTEXT
