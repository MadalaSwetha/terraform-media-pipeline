// ec2.tf
resource "aws_key_pair" "ssh_key" {
  key_name   = "${var.project}-key"
  public_key = file(var.ssh_public_key_path)
}

resource "aws_instance" "jenkins_host" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2 (verify latest)
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = aws_key_pair.ssh_key.key_name

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install docker -y
    systemctl enable docker
    systemctl start docker
    usermod -aG docker ec2-user

    curl -L "https://github.com/docker/compose/releases/download/2.24.5/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    mkdir -p /opt/stack/prometheus /opt/stack/grafana /opt/stack/jenkins

    cat > /opt/stack/prometheus/prometheus.yml <<'PROM'
    global:
      scrape_interval: 15s
    scrape_configs:
      - job_name: 'node_exporter'
        static_configs:
          - targets: ['localhost:9100']
    PROM

    cat > /opt/stack/docker-compose.yml <<'COMPOSE'
    services:
      jenkins:
        image: jenkins/jenkins:lts
        container_name: jenkins
        ports:
          - "8080:8080"
          - "50000:50000"
        volumes:
          - /opt/stack/jenkins:/var/jenkins_home
        restart: unless-stopped

      prometheus:
        image: prom/prometheus
        container_name: prometheus
        ports:
          - "9090:9090"
        volumes:
          - /opt/stack/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
        restart: unless-stopped

      grafana:
        image: grafana/grafana
        container_name: grafana
        ports:
          - "3000:3000"
        volumes:
          - /opt/stack/grafana:/var/lib/grafana
        restart: unless-stopped
    COMPOSE

    docker run -d --name node_exporter -p 9100:9100 --restart unless-stopped prom/node-exporter

    cd /opt/stack
    /usr/local/bin/docker-compose up -d
  EOF

  tags = { Name = "${var.project}-jenkins-host" }
}