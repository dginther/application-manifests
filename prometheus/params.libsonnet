{
  containerPort: 9090,
  image: "prom/prometheus:v2.23.0",
  name: "prometheus",
  replicas: 1,
  servicePort: 9090,
  type: "LoadBalancer",
}
