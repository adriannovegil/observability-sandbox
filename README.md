# Observability Sandbox

Get up and running a sandbox with Prometheus, Grafana, and more using Docker and Docker Compose

## Fast Run

Clone this repo and execute the following command:

```
make up
```

This command start a minimal observability infrastructure with the basic configuration.

If you wan to check more execution options, you can execute:

```
make help
```

## Services

The following services will be started. Some of them are accessible via web:

### Dashboarding

| Component                                  | Description                                                  | Port                              |
| ---------------------------------------    | ---------------------------------------------------------    | --------------------------------- |
| `grafana-server`                           | [Grafana](https://grafana.com/)                              | [`3000`](http://localhost:3000)   |

### Storage

| Component                                  | Description                                                  | Port                              |
| ---------------------------------------    | ---------------------------------------------------------    | --------------------------------- |
| `prometheus-server`                        | [Prometheus](https://prometheus.io/)                         | [`9090`](http://localhost:9090)   |

### Tracing

| Component                                  | Description                                                  | Port                              |
| ---------------------------------------    | ---------------------------------------------------------    | --------------------------------- |
| `zipking`                                  | [Zipkin](https://zipkin.io/)                                 | [`9411`](http://localhost:9411)   |
| `jaeger`                                   | [Jaeger](https://www.jaegertracing.io/)                      | [`16686`](http://localhost:16686) |

### Logs

| Component                                  | Description                                                  | Port                             |
| ---------------------------------------    | ---------------------------------------------------------    | -------------------------------- |
| `Elasticsearch`                            | [Elasticsearch](https://www.elastic.co/)                     | [`9200`](http://localhost:9200)  |
| `Logstash`                                 | [Logstash](https://www.elastic.co/)                          | [`9600`](http://localhost:9600)  |
| `Kibana`                                   | [Kibana](https://www.elastic.co/)                            | [`5601`](http://localhost:5601)  |

### Self Monitoring

| Component                                  | Description                                                  | Port                             |
| ---------------------------------------    | ---------------------------------------------------------    | -------------------------------- |
| `cadvisor`                                 | [cAdvisor](https://github.com/google/cadvisor)               | [`8010`](http://localhost:8010)  |
| `node-exporter`                            | [Node Exporter](https://github.com/prometheus/node_exporter) | [`9100`](http://localhost:9100)  |

## Configuration

Following you can check the confgiuration options

### Prometheus

By default, Prometheus is configured with a basic targets. Metrics from the host where you are executing the project:

```
# Node exporter
- job_name: 'nodeexporter'
  scrape_interval: 5s
  static_configs:
    - targets: ['node-exporter:9100']

# cAdvisor
- job_name: 'cadvisor'
  scrape_interval: 5s
  static_configs:
    - targets: ['cadvisor:8080']
```

The Prometheus server:

```
# Prometheus self monitoring
# Prometheus
- job_name: prometheus
  honor_timestamps: true
  scrape_interval: 5s
  scrape_timeout: 3s
  metrics_path: /metrics
  scheme: http
  static_configs:
    - targets:
      - prometheus-server:9090
```

Zipking and Jaeger Metrics:

```
# Zipkin
- job_name: 'zipkin'
  scrape_interval: 5s
  metrics_path: '/prometheus'
  static_configs:
    - targets: ['zipkin:9411']
  metric_relabel_configs:
    # Response code count
    - source_labels: [__name__]
      regex: '^status_(\d+)_(.*)$'
      replacement: '${1}'
      target_label: status
    - source_labels: [__name__]
      regex: '^status_(\d+)_(.*)$'
      replacement: '${2}'
      target_label: path
    - source_labels: [__name__]
      regex: '^status_(\d+)_(.*)$'
      replacement: 'http_requests_total'
      target_label: __name__

# Jaeger
- job_name: 'jaeger'
  scrape_interval: 5s
  static_configs:
    - targets: ['jaeger:14269']

```

And Spring Petclinic Targets:

```
# Spring petclinic services monitoring
# You can use Eureka's application instance metadata.
# If you are using SpringBoot, you can add metadata using eureka.instance.metadataMap like this:
# application.yaml (spring-boot)
# eureka:
#  instance:
#    metadataMap:
#      "prometheus.scrape": "true"
#      "prometheus.path": "/actuator/prometheus"
- job_name: eureka-discovery
  metrics_path: /actuator/prometheus
  scrape_interval: 15s
  scrape_timeout: 15s
  eureka_sd_configs:
  - server: http://discovery-server:8761/eureka
    refresh_interval: 30s
  relabel_configs:
  # Relabel to customize metric path based on application
  # "prometheus.path = <metric path>" annotation.
  - source_labels: [__address__, __meta_eureka_app_instance_metadata_prometheus_port]
    action: replace
    regex: ([^:]+)(?::\d+)?;(\d+)
    replacement: $1:$2
    target_label: __address__
  # Relabel to scrape only application that have
  # "prometheus.scrape = true" metadata.
  - source_labels: [__meta_eureka_app_instance_metadata_prometheus_scrape]
    action: keep
    regex: true
```

In the case of the Spring Pet Clinic metrics we discover the targets using the Eureka server of the project.

If you want to add a new target or change the current confgiuration you can do it in the following [file](./metrics/prometheus/prometheus-server/prometheus.yml):

```
./metrics/prometheus/prometheus-server/prometheus.yml
```

If you need information about this config file, you can check the Prometheus official documentation [here](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)

### Grafana

The project comes with a minimal set of Grafana dashboads to check the metrics collected from the host and the core services (Prometheus, Zipkin, Jaeger, etc.)

If you want to add a new Dashboard, you can create a new folder edditing the following file:

```
./dashboarding/grafana/grafana-server/etc/provisioning/dashboards/dashboards.yaml
```

Here you can see and example:

```
- name: 'Jaeger'
  orgId: 1
  folder: 'Self Monitoring'
  folderUid: ''
  type: file
  disableDeletion: true
  editable: true
  updateIntervalSeconds: 10
  allowUiUpdates: true
  options:
    path: /var/lib/grafana/dashboards/jaeger
```

Then, just put the dashboards in the configured folder for this:

```
./dashboarding/grafana/grafana-server/dashboards/
```

## Contributing

For a complete guide to contributing to the project, see the [Contribution Guide](CONTRIBUTING.md).

We welcome contributions of any kind including documentation, organization, tutorials, blog posts, bug reports, issues, feature requests, feature implementations, pull requests, answering questions on the forum, helping to manage issues, etc.

The project community and maintainers are very active and helpful, and the project benefits greatly from this activity.

### Reporting Issues

If you believe you have found a defect in the project or its documentation, use the repository issue tracker to report the problem to the project maintainers.

If you're not sure if it's a bug or not, start by asking in the discussion forum. When reporting the issue, please provide the version.

### Submitting Patches

The project welcomes all contributors and contributions regardless of skill or experience level.

If you are interested in helping with the project, we will help you with your contribution.

We want to create the best possible tool for our development teams and the best contribution experience for our developers, we have a set of guidelines which ensure that all contributions are acceptable.

The guidelines are not intended as a filter or barrier to participation. If you are unfamiliar with the contribution process, the team will help you and teach you how to bring your contribution in accordance with the guidelines.

For a complete guide to contributing, see the [Contribution Guide](CONTRIBUTING.md).

## Code of Conduct

See the [code-of-conduct.md](./code-of-conduct.md) file

## License

See the [LICENSE](./LICENSE) file
