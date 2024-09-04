openssl req -x509 -sha256 -newkey rsa:2048 -keyout webhook.key -out webhook.crt -days 1024 -nodes -addext "subjectAltName = DNS.1:awesome-mutator.castai-agent.svc"
kubectl create secret generic awesome-mutator-tls -n castai-agent --from-file=webhook.crt=webhook.crt  --from-file=webhook.key=webhook.key --dry-run=true -o yaml
helm upgrade -i -n castai-agent awesome-mutator .

cat webhook.crt | base64 | tr -d '\n'
