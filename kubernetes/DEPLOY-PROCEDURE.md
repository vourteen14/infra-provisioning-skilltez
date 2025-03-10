1. Install All In helm-values directory
2. Install deployments.yaml `kubectl apply -f deployments.yaml`
3. Install certs.yaml `kubectl apply -f certs.yaml`
4. Install ingress.yaml `kubectl apply -f ingress.yaml`

Note: Once the emissary service get the public IP, immediately add the public IP into the domain record, because it may take up to 30 minutes after GKE can complete it for the acme challenge, then the acme challenge for getting certificate will run smoothly