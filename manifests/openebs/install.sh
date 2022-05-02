#!/bin/bash

helm repo add openebs https://openebs.github.io/charts
helm repo update
helm install --namespace openebs --name openebs openebs/openebs
