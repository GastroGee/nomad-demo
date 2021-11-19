job "monitoring" {
  datacenters = ["dc1"]
  
  type = "service"

  group "grafana" {
    count = 1  
    restart {
      attempts = 10
      interval = "5m"
      delay = "10s"
      mode = "delay"
    }
    network {
      port "http" {
      }
    }

    task "grafana" {
      driver = "docker"

      config {
        image = "grafana/grafana:latest"

        ports = ["http"]
      }
      artifact {
        source      = "github.com/gastrogee/nomad-demo/grafana/provisioning"
        destination = "local/provisioning/"
      }

      artifact {
        source      = "github.com/gastrogee/nomad-demo/grafana/dashboards"
        destination = "local/dashboards/"
      }
      env {
        GF_LOG_LEVEL = "DEBUG"
        GF_LOG_MODE = "console"
        GF_SERVER_HTTP_PORT = "${NOMAD_PORT_http}"
        GF_PATHS_PROVISIONING = "/local/provisioning"
      }


      resources {
        cpu    = 200 # 500 MHz
        memory = 256 # 256MB
      }
    }
  }
}
