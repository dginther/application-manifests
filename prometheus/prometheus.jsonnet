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
                        },
                     ],
                     "volumeMounts": [
                        {
                           "name": params.vol_name,
                           "mountPath": params.vol_mount_path
                        },
                     ]
                  }
               ],
               "volumes": [
                  {
                     "name": params.vol_name,
                     "configMap": {
                        "name": params.vol_configmap_name,
                     }
                  },
               ],
            }
         }
      }
   },
   {
      "apiVersion": "v1",
      "kind": "ConfigMap",
      "metadata": {
         "name": params.vol_configmap_name,
         "labels": {
            "name": params.name,
         },
      },
      "data": {         
         "prometheus.yml": params.config
      },
   },
   {
      "apiVersion": "v1",
      "kind": "Pod",
      "data": {         
         "prometheus.yml": params.config
      },
   }
]
