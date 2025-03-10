#### Add required helm repository
helm repo add jetstack https://charts.jetstack.io
helm repo add datawire https://app.getambassador.io
helm repo add airbyte https://airbytehq.github.io/helm-charts
#### Update Helm repo
helm repo update
#### Creds for emissary
kubectl apply -f https://app.getambassador.io/yaml/emissary/latest/emissary-crds.yaml
#### Deploy cert-manager
helm upgrade --install cert-manager jetstack/cert-manager -n cert-manager -f cert-manager-values.yaml
#### Deploy emisary
helm upgrade --install emissary-ingress datawire/emissary-ingress -n emissary -f emissary-values.yaml
#### Deploy airbyte
helm upgrade --install airbyte airbyte/airbyte -n airbyte -f airbyte-values.yaml