#!/bin/bash
touch report.md
printf  "# Getting Deployment Details\n\n" | tee -a report.md
printf  "## Supplied Variables\n\n" | tee -a report.md
printf  "\tNamespace: $NAMESPACE\n" | tee -a report.md
printf  "\tNodePort: $NODE_PORT\n" | tee -a report.md
printf  "\n## Kubernetes Pods\n\n" | tee -a report.md
kubectl get pods -n $NAMESPACE | tee -a report.md
printf  "\n\n## Kubernetes Services\n" | tee -a report.md
kubectl get svc -n $NAMESPACE | tee -a report.md
printf  "\n\n## Cilium Status\n\n" | tee -a report.md
cilium status | tee -a report.md
printf  "\n\n## Cilium Flows\n\n" | tee -a report.md
printf "$(hubble observe -n $NAMESPACE)" | tee -a report.md
printf  "\n\n## Terraform Data\n\n" | tee -a report.md
printf "$TF_DATA" | tee -a report.md
printf  "\n\n## Reachability Test\n\n" | tee -a report.md
printf "$REACHABLE" | tee -a report.md