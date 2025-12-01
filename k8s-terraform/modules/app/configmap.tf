resource "kubernetes_config_map" "nginx_config" {
  metadata {
    name      = "nginx-config"
    namespace = var.namespace
  }

  data = {
    "index.html" = <<-EOF
      <!DOCTYPE html>
      <html>
      <head><title>Terraform K8s Demo</title></head>
      <body>
        <h1>Hello Anurupa, from Kubernetes!</h1>
        <p>You have succesfully is served the page from a ConfigMap</p>
        <p>Environment: ${var.environment}</p>
        <p>Namespace: ${var.namespace}</p>
      </body>
      </html>
    EOF

    "nginx.conf" = <<-EOF
      server {
        listen 80;
        server_name localhost;
        
        location / {
          root /usr/share/nginx/html;
          index index.html;
        }
        
        location /health {
          access_log off;
          return 200 "healthy\n";
        }
      }
    EOF
  }
}