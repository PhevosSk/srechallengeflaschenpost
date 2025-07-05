# Kubernetes Shop Backend Deployment

This project contains Kubernetes manifests for deploying a scalable, secure shop backend API.

## Overview

The solution includes:
- **Deployment**: A secure, production-ready deployment with health checks
- **Service**: ClusterIP service for internal communication
- **HPA**: Horizontal Pod Autoscaler for automatic scaling
- **CronJob**: Scheduled job that outputs "Hello SRE" every 30 minutes

## Files

- `shopbackendAPI.yaml` - Main deployment, service, and CronJob configuration
- `hpa.yaml` - Horizontal Pod Autoscaler for auto-scaling

## Features

### Security
- Non-root user execution (`runAsUser: 1000`)
- Read-only root filesystem
- Dropped all capabilities
- No privilege escalation allowed
- AppArmor runtime/default profile for additional container security
  - File System: Restricts access to sensitive system files
  - Network: Limits certain network operations
  - Process: Prevents dangerous system calls
  - Mount: Restricts mount operations
  - Capabilities: Works with your securityContext.capabilities.drop: [ALL]

### Scalability
- Horizontal Pod Autoscaler (HPA) configured
- Scales from 3 to 10 pods based on CPU utilization (60% threshold)
- Rolling updates with zero downtime
- Resource requests and limits defined for proper scheduling

### Health Checks
- **Liveness Probe**: TCP check on port 80 (initial delay: 10s)
- **Readiness Probe**: HTTP GET to "/" on port 80 (initial delay: 10s, period: 1s, failure threshold: 2)

## Deployment Instructions

### Prerequisites
- Container runtime (Docker was used)
- Kubernetes cluster (Minikube was used)
- kubectl CLI configured
- Metrics server installed (for HPA)

### Deploy the Application
```bash
# Deploy the main application
kubectl apply -f shopbackendAPI.yaml

# Deploy the HPA
kubectl apply -f hpa.yaml
```

### Verify Deployment
```bash
# Check deployment status
kubectl get deployments

# Check pod status
kubectl get pods

# Check HPA status
kubectl get hpa

# Check service
kubectl get svc
```

## Generate Traffic for HPA Testing

To trigger the HPA and test auto-scaling:

```bash
# Using minikube service (recommended for minikube)
while true; do curl -s $(minikube service shopbackend --url) > /dev/null; sleep 0.2; done

## Health Check

The deployment includes comprehensive health checks and resource monitoring:
- Liveness and readiness probes for container health
- Resource requests and limits for proper scheduling
- Security context and AppArmor for runtime protection

## Notes

- The deployment runs in the `default` namespace
- Service uses ClusterIP for internal communication
- CronJob runs every 30 minutes and outputs "Hello SRE" to logs

