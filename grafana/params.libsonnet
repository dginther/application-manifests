{
  containerPort: 3000,
  image: "grafana/grafana:7.3.1",
  name: "grafana",
  replicas: 1,
  servicePort: 3000,
  type: "LoadBalancer",
}
