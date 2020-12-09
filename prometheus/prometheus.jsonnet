local params = import 'params.libsonnet';

[
   {
      "apiVersion": "v1",
      "kind": "Service",
      "metadata": {
         "name": params.name
      },
      "spec": {
         "ports": [
            {
               "port": params.servicePort,
               "targetPort": params.containerPort
            }
         ],
         "selector": {
            "app": params.name
         },
         "type": params.type
      }
   },
   {
      "apiVersion": "apps/v1",
      "kind": "Deployment",
      "metadata": {
         "name": params.name
      },
      "spec": {
         "replicas": params.replicas,
         "revisionHistoryLimit": 3,
         "selector": {
            "matchLabels": {
               "app": params.name
            },
         },
         "template": {
            "metadata": {
               "labels": {
                  "app": params.name
               }
            },
            "spec": {
               "containers": [
                  {
                     "image": params.image,
                     "name": params.name,
                     "ports": [
                     {
                        "containerPort": params.containerPort
                     }
                     ]
                  }
               ]
            }
         }
      }
   },
   {
      "apiVersion": "v1",
      "kind": "ConfigMap",
      "metadata": {
         "name": params.name,
         "labels": {
            "name": params.name,
         },
      },
      "data": {         
         "prometheus.yml": "|-
            global:
               scrape_interval: 5s
               evaluation_interval: 5s
            scrape_configs:
               - job_name: kubernetes-nodes-cadvisor
                 scrape_interval: 10s
                 scrape_timeout: 10s
                 scheme: https  # remove if you want to scrape metrics on insecure port
                 tls_config:
                     ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
                 bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
                 kubernetes_sd_configs:
                     - role: node
                 relabel_configs:
                     - action: labelmap
                       regex: __meta_kubernetes_node_label_(.+)
                       # Only for Kubernetes ^1.7.3.
                       # See: https://github.com/prometheus/prometheus/issues/2916
                     - target_label: __address__
                       replacement: kubernetes.default.svc:443
                     - source_labels: [__meta_kubernetes_node_name]
                       regex: (.+)
                       target_label: __metrics_path__
                       replacement: /api/v1/nodes/${1}/proxy/metrics/cadvisor
                  metric_relabel_configs:
                     - action: replace
                       source_labels: [id]
                       regex: '^/machine\.slice/machine-rkt\\x2d([^\\]+)\\.+/([^/]+)\.service$'
                       target_label: rkt_container_name
                       replacement: '${2}-${1}'
                     - action: replace
                       source_labels: [id]
                       regex: '^/system\.slice/(.+)\.service$'
                       target_label: systemd_service_name
                       replacement: '${1}'"
      },
   }
]
