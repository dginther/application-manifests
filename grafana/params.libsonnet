{
  containerPort: 80,
  image: "grafana/grafana:7.3.1",
  name: "grafana",
  replicas: 1,
  servicePort: 8080,
  type: "LoadBalancer",
}
