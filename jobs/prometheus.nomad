job "prometheus" {
  datacenters = ["dc1"]
  
  type = "service"

  group "prometheus" {
    count = 1  
    restart {
      attempts = 10
      interval = "5m"
      delay = "10s"
      mode = "delay"
    }
    network {
      port "http" {
        static = "9090"
      }
    }
    task "prometheus" {
      driver = "docker"

      config {
        image = "prom/prometheus:latest"
        mount {
          type   = "bind"
          source = "local"
          target = "/etc/prometheus"
        }
        ports = ["http"]
      }
      artifact {
        source      = "github.com/gastrogee/nomad-demo/prometheus/prometheus.yml"
        destination = "local/prometheus.yml"
      }
      resources {
        cpu    = 100 # 500 MHz
        memory = 256 # 256MB
      }
    }
  }  
}
