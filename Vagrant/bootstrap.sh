#!/bin/bash

# Aumentar el valor de vm.max_map_count
sudo sysctl -w vm.max_map_count=262144

# Actualizar los paquetes de apt
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl lsb-release

# Agregar la clave GPG oficial de Docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Agregar el repositorio de Docker a las fuentes de apt
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Actualizar los repositorios
sudo apt-get update

# Instalar Docker y Docker Compose Plugin desde el repositorio oficial
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verificar la instalación de Docker
docker --version

# Verificar la instalación de Docker Compose
docker compose version

# Usar Docker sin sudo
sudo groupadd docker
sudo usermod -aG docker vagrant
newgrp docker

# Clonar repositorio github
git clone https://github.com/fcongedo/jenkins-prometheus-grafana-sonarqube.git

# Navegar al directorio del repositorio clonado
cd prueba

# Ejecutar el comando de construcción de las imágenes Docker
sudo docker compose build --pull --no-cache & sudo docker compose up --detach &
wait


# Mostrar los contenedores corriendo
docker ps
