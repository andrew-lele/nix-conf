{ config, ... }:
let
  ports = import ./custom-ports.nix;
  grafana = {
    enable = true;
    settings.server = {
      domain = "grafana.andle.day";
      http_port = ports.grafana;
      http_addr = "10.1.30.103";
    };
    provision = {
      enable = true;
      # declarativePlugins = with pkgs.grafanaPlugins; [ ... ];
      #
      dashboards.settings.providers = [
        {
          name = "my dashboards";
          options.path = "/etc/grafana-dashboards";
        }
      ];

      datasources.settings.datasources = [
        # "Built-in" datasources can be provisioned - c.f. https://grafana.com/docs/grafana/latest/administration/provisioning/#data-sources
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://${toString config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
        }
        # Some plugins also can - c.f. https://grafana.com/docs/plugins/yesoreyeram-infinity-datasource/latest/setup/provisioning/
        {
          name = "Loki";
          type = "loki";
          url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
        }
        # But not all - c.f. https://github.com/fr-ser/grafana-sqlite-datasource/issues/141
      ];

      # Note: removing attributes from the above `datasources.settings.datasources` is not enough for them to be deleted on `grafana`;
      # One needs to use the following option:
      # datasources.settings.deleteDatasources = [ { name = "foo"; orgId = 1; } { name = "bar"; orgId = 1; } ];
    };

    # datasources = [
    #   {
    #     name = "Prometheus";
    #     type = "prometheus";
    #     url = "http://127.0.0.1:${toString config.services.prometheus.port}";
    #   }
    #   {
    #   }
    # ];
  };
  prometheus = {
    enable = true;
    port = ports.prometheus;
    exporters = {
      node = {
        port = ports.prometheusNode;
        enabledCollectors = [ "systemd" ];
        enable = true;
      };
    };

    scrapeConfigs = [
      {
        job_name = "nodes";
        static_configs = [
          {
            targets = [
              "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
            ];
          }
        ];
      }
    ];

  };
  loki = {
    enable = true;
    configuration = {
      schema_config = {
        configs = [
          {
            from = "2024-12-24";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };
      server.http_listen_port = 3030;
      auth_enabled = false;

      ingester = {
        lifecycler = {
          address = "127.0.0.1";
          ring = {
            kvstore = {
              store = "inmemory";
            };
            replication_factor = 1;
          };
        };
        chunk_idle_period = "1h";
        max_chunk_age = "1h";
        chunk_target_size = 999999;
        chunk_retain_period = "30s";
      };

      storage_config = {
        tsdb_shipper = {
          active_index_directory = "/var/lib/loki/tsdb-index";
          cache_location = "/var/lib/loki/tsdb-cache";
          cache_ttl = "24h";
        };

        filesystem = {
          directory = "/tmp/loki/";
        };
      };

      limits_config = {
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
      };

      table_manager = {
        retention_deletes_enabled = false;
        retention_period = "0s";
      };

      compactor = {
        working_directory = "/var/lib/loki";
        compactor_ring = {
          kvstore = {
            store = "inmemory";
          };
        };
      };
    };
  };
  tempo = {
    enable = true;
    settings = {
      stream_over_http_enabled = true;
      server = {
        http_listen_port = ports.tempo;
        log_level = "info";
      };
      cache = {
        background.writeback_goroutines = 5;
      };
      query_frontend = {
        search = {
          duration_slo = "5s";
          throughput_bytes_slo = 1.073741824e9;
          metadata_slo = {
            duration_slo = "5s";
            throughput_bytes_slo = 1.073741824e9;
          };
        };
      };
      trace_by_id.duration_slo = "100ms";
      metrics = {
        max_duration = "120h";
        query_backend_after = "5m";
        duration_slo = "5s";
        throughput_bytes_slo = 1.073741824e9;
      };
      distributor = {
        receivers = {
          jaeger = {
            protocols = {
              thrift_http = {
                endpoint = "tempo:${toString ports.tempoThriftHttp}";
              };
              grpc = {
                endpoint = "tempo:${toString ports.tempoThriftGrpc}";
              };
              thrift_binary = {
                endpoint = "tempo:${toString ports.tempoThriftBinary}";
              };
              thrift_compact = {
                endpoint = "tempo:${toString ports.tempoThriftCompact}";
              };
            };
          };
          # zipkin = {
          #   endpoint = "tempo:9411";
          # };
          # otlp = {
          #   protocols = {
          #     grpc = {
          #       endpoint = "tempo:4317";
          #     };
          #     http = {
          #       endpoint = "tempo:4318";
          #     };
          #   };
          # };
          # opencensus = {
          #   endpoint = "tempo:55678";
          # };
        };
      };

      ingester = {
        max_block_duration = "5m";
      };

      compactor = {
        compaction = {
          block_retention = "24h";
        };
      };

      metrics_generator = {
        registry = {
          external_labels = {
            source = "tempo";
            worker = "jihun";
          };
        };
        storage = {
          path = "/var/lib/tempo/generator/wal";
          remote_write = [
            {
              url = "http://127.0.0.1:${toString ports.prometheus}/api/v1/write";
              send_exemplars = true;
            }
          ];
        };
        traces_storage = {
          path = "/var/lib/tempo/generator/traces";
        };
        processor = {
          local_blocks = {
            filter_server_spans = false;
            flush_to_storage = true;
          };
        };
      };

      storage = {
        trace = {
          backend = "local";
          wal = {
            path = "/var/lib/tempo/wal";
          };
          local = {
            path = "/var/lib/tempo/blocks";
          };
        };
      };

      overrides = {
        defaults = {
          metrics_generator = {
            processors = [
              "service-graphs"
              "span-metrics"
              "local-blocks"
            ];
            generate_native_histograms = "both";
          };
        };
      };
    };
  };
in
{
  services = {
    inherit grafana;
    inherit loki;
    inherit prometheus;
    inherit tempo;

  };
}
