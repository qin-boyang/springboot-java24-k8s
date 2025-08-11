# Spring Boot with Java 24 on Local Docker Desktop Kubernetes

## Overview

This project demonstrates a simple Spring Boot application (using Java 24) 
configured to run on a local Kubernetes cluster via Docker Desktop. 
It includes all necessary configurations and troubleshooting steps for local development.

## Prerequisites

- Docker Desktop with Kubernetes enabled
- JDK 24 installed
- Maven 3.9+
- kubectl command-line tool

## Project Structure

```
springboot-java24-k8s/
├── src/
│   ├── main/
│   │   ├── java/com/example/demo/
│   │   │   ├── DemoApplication.java
│   │   │   └── HelloController.java
│   │   └── resources/
│   │       └── application.properties
├── Dockerfile
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
└── pom.xml
```

## Setup Instructions

### 1. Enable Kubernetes in Docker Desktop

1. Open Docker Desktop
2. Go to Settings → Kubernetes
3. Check "Enable Kubernetes"
4. Click "Apply & Restart"

### 2. Verify Kubernetes Context

```bash
# Set correct context (to use Docker Desktop's Kubernetes directly)
# Switch to Docker Desktop Context
kubectl config use-context docker-desktop

# Verify
kubectl config current-context
# Should return "docker-desktop"
```

### 3. Build and Deploy

```bash
# Build the application
./mvnw clean package

# Build Docker image
docker build -t springboot-java24 .

# Deploy to Kubernetes
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

## Verification

```bash
# Check pod status
kubectl get pods -w

# Check service
kubectl get svc

# View logs
kubectl logs -f deployment/springboot-java24
```

## Access the Application

### NodePort (if configured)
Check your service's NodePort:
```bash
kubectl get svc springboot-java24-service
```
Typically available at: http://localhost:30080

## API Endpoints

- `GET /` - Welcome message
- `GET /health` - Health check

## Troubleshooting

### Common Issues

1. **ImagePullBackOff/ErrImageNeverPull**
    - Verify correct context: `kubectl config current-context`
    - Rebuild image: `docker build -t springboot-java24 .`
    - Redeploy: `kubectl rollout restart deployment springboot-java24`

2. **Port conflicts**
    - Change NodePort in `service.yaml` (30000-32767 range)

3. **Application not starting**
    - Check logs: `kubectl logs <pod-name>`

### Cleanup

```bash
# Delete deployment
kubectl delete -f k8s/deployment.yaml
kubectl delete -f k8s/service.yaml

# Remove Docker image
docker rmi springboot-java24
```

## Best Practices

1. Always verify your Kubernetes context before deployment
2. During development, use `imagePullPolicy: Never` for local images
3. For production, push images to a registry and use proper tags
4. Monitor resources with:
   ```bash
   kubectl top pods
   kubectl get events --sort-by=.metadata.creationTimestamp
   ```

## License

This project is open-source and available under the MIT License.