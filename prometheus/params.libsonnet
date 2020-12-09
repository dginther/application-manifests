{
  containerPort: 9090,
  image: "prom/prometheus:v2.23.0",
  name: "grafana",
  replicas: 1,
  servicePort: 9090,
  type: "LoadBalancer",
}
