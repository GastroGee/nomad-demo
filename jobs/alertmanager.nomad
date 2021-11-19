job "alertmanager" {
  datacenters = ["dc1"]
  
  type = "service"

  group "alertmanager" {
    count = 1  
    restart {
      attempts = 10
      interval = "5m"
      delay = "10s"
      mode = "delay"
    }
    network {
      port "http" {
        static = "9093"
      }
    }
    task "prometheus" {
      driver = "docker"

      config {
        image = "prom/alertmanager:latest"
        mount {
          type   = "bind"
          source = "local"
          target = "/etc/alertmanager"
        }
        ports = ["http"]
      }
      artifact {
        source      = "github.com/gastrogee/nomad-demo/alertmanager/alertmanager.yml"
        destination = "local/alertmanager.yml"
      }
      resources {
        cpu    = 200 # 500 MHz
        memory = 256 # 256MB
      }
    }
  } 
}
