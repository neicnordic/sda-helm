#!/bin/bash

helm list --short 2>/dev/null | while read -r release; do
    echo "Testing $release"
    helm test "$release"
    r=$?

    if [ "$r" -ne 0 ]; then
	kubectl get pod -o name | while read -r pod; do
	    echo "All logs for $pod"
	    kubectl logs --all-containers "$pod"
	done
	exit "$r"
    fi
done
							  
