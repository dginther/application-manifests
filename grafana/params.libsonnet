{
  containerPort: 3000,
  image: "grafana/grafana:7.3.4",
  name: "grafana",
  replicas: 1,
  servicePort: 3000,
  type: "LoadBalancer",
}
