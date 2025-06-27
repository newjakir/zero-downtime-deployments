# Zero‑Downtime Kubernetes Deployments Report
Your Name
Date
Course / Module 11 Assignment

1. Introduction
Explain the goal:

Demonstrate zero-downtime application updates with Blue-Green, Rolling, and Canary deployment patterns using Docker + Kubernetes (plus Argo Rollouts for canary).

2. Application & Docker Images
App shows version in HTML: “Version 1” (v1), “Version 2” (v2).

Docker setup:

Base: FROM node:16-alpine

Copies versioned expressjs application to serve on port 3000.

Docker Hub tags:

yourusername/bluegreen-app:v1 → v1 image

…:v2 → v2 image

…:latest → updated each time

3. Blue‑Green Deployment
Manifests:

blue-deployment.yaml (v1), green-deployment.yaml (v2)

service.yaml initially selects blue

Switch procedure:

Deploy both blue and green versions.

Service selector switches from version=blue → version=green

Clients reconnect to green pods seamlessly.

Zero downtime:

Switching occurs instantly at kubectl patch svc

No traffic loss or 404s; existing connections drained gracefully.

Proof:

Screenshot of curl during switch showing continuous output (“Version 2”).

Service response logs.

4. Rolling Update Strategy
Manifest:

rolling-deployment.yaml with:

yaml
Copy
Edit
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
Ensures one new pod is spun up before an old one is terminated → no downtime

Procedure:

Deploy v1

Push v2 image

kubectl set image deployment/rolling-app app=…:v2

Zero downtime:

maxUnavailable: 0 ensures constant number of healthy pods.

Proof:

kubectl rollout status deployment/rolling-app

curl during update continues to show "Version 2" seamlessly.

5. Canary Deployment with Argo Rollouts (Optional)
Setup:

Installed Argo Rollouts in cluster.

rollout.yaml with canary strategy:

markdown
Copy
Edit
steps:
  - setWeight: 20
  - pause
  - setWeight: 60
  - pause
  - setWeight: 100
Procedure:

Deploy v1 via Rollout

Push v2 image

Patch rollout to v2

Argo shifts traffic gradually (20 → 60 → 100%)

Zero downtime:

Traffic only transitions when new pods are healthy.

Pause steps allow monitoring/rollback.

Proof:

kubectl argo rollouts get rollout canary-app --watch

Screenshots showing each traffic weight.

Browser or curl showing both versions served during canary.

6. Conclusion
Summarize:

Blue-Green: service switch handles full cutover.

Rolling: Kubernetes native ensures pods upgraded one-by-one.

Canary: finer control and validation before full rollout.

7. Appendices (optional)
Full output logs, screenshots, curl command lines.

kubectl get pods, kubectl describe svc, etc.

🎯 Next Steps
Create your repo using the template above.

Populate Dockerfiles, manifests, report.md with your specifics.

Push images to Docker Hub and fix names in YAMLs.

Test each strategy locally (Minikube/kind) or in the cloud.

Capture screenshots or terminal logs for zero‑downtime proof.

Write your report using the draft as a starting point.