# Grafana Dashboards Reference

To declaratively import Grafana dashboards using a ConfigMap resource or as part of the [kube-prometheus-stack Helm Chart values.yaml](../kube-prometheus-stack-values.yaml), you may have to modify the Grafana dashboard JSON and remove the `__inputs` key, set the `Prometheus` Data Source name, and get a one-line JSON format.

The following is a reference for the steps I took to deploy the `kube-prometheus-stack` Helm Chart and embed the Grafana dashboards as part of it.

First, obtain the Grafana dashboards locally. In this example, I use the following dashboards.

```text
# NVIDIA GPU Dashboard rev1: https://grafana.com/api/dashboards/18288/revisions/1/download
nvidia-gpu_rev1.json

# NVIDIA DCGM Exporter Dashboard rev2: https://grafana.com/api/dashboards/12239/revisions/2/download
nvidia-dcgm-exporter-dashboard_rev2.json
```

Using `jq` and `sed` you can remove the `__inputs` key, set the `Prometheus` Data Source name, and get a one-line JSON format for embedding the dashboards in your Grafana deployment.

```bash
# Clean up first
rm -f *result.json

# Loop through the dashboards
for dashboard_file in $(ls source-dashboards/*.json); do
  jq . "$dashboard_file" \
  | jq 'del(.__inputs)' \
  | sed 's|${DS_PROMETHEUS}|Prometheus|g' \
  | jq -c > "$(echo "$dashboard_file" | cut -d'.' -f1)-result.json"
done
```

You can then use the resulting `*-result.json` files and set them in your ConfigMap to create the dashboards as part of the `kube-prometheus-stack` Helm deployment. Refer to the `../kube-prometheus-stack-values.yaml` manifest.
