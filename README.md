# Observability Sandbox

Get up and running with Prometheus, Grafana, and more using Docker and Docker Compose

## Fast Run

Clone this repo and execute the following command:

```
make up
```

## Services

The following services will be started. Some of them are accessible via web:

### Dashboarding

| Component                                  | Description                                                 | Port      |
| ---------------------------------------    | --------------------------------------------------------    | -------------------------------    |
| `grafana-server`                           | Grafana                                                     | [`3000`](http://localhost:3000)    |

### Storage

| Component                                  | Description                                                 | Port                               |
| ---------------------------------------    | --------------------------------------------------------    | -------------------------------    |
| `prometheus-server`                        | Prometheus                                                  | [`9090`](http://localhost:9090)    |

### Self Monitoring

| Component                                  | Description                                                 | Port                               |
| ---------------------------------------    | --------------------------------------------------------    | --------------------------------   |
| `cadvisor`                                 | cAdvisor                                                    | [`8010`](http://localhost:8010)    |
| `node-exporter`                            | Node Exporter                                               | [`9100`](http://localhost:9100)    |

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
