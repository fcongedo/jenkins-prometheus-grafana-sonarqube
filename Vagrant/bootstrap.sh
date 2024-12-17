#!/bin/bash

# Funciones de colores
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sin color

# Título antes de la instalación
echo -e "\n${CYAN}########################################################"
echo -e "##    🚀  INICIANDO LA INSTALACIÓN Y CONFIGURACIÓN     ##"
echo -e "##    DE DOCKER, DOCKER COMPOSE Y LOS CONTENEDORES       ##"
echo -e "##   DE JENKINS, PROMETHEUS, GRAFANA Y SONARQUBE 🚀    ##"
echo -e "#########################################################${NC}\n"

# Número total de pasos
TOTAL_STEPS=15
CURRENT_STEP=0

# Función para mostrar el porcentaje de progreso con barra gráfica
progress_bar() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    PERCENTAGE=$(( (CURRENT_STEP * 100) / TOTAL_STEPS ))
    BAR_WIDTH=$((PERCENTAGE / 5))  # Cada unidad es el 5% (20 pasos en total)
    
    # Crear barra de progreso
    BAR=$(printf "%-${BAR_WIDTH}s" "#" | tr ' ' '#')
    EMPTY=$(printf "%-$((20 - BAR_WIDTH))s")
    echo -ne "[${GREEN}${BAR}${NC}${EMPTY}] ${PERCENTAGE}% 🛠️\r"
}

# Función para mostrar mensajes importantes con color
echo_message() {
    echo -e "\n${BLUE}$1${NC}"
}

# Función para ejecutar comandos y redirigir su salida
run_command() {
    "$@" > /dev/null 2>&1
}

# Aumentar el valor de vm.max_map_count
echo_message "🛠️  Aumentando vm.max_map_count..."
run_command sudo sysctl -w vm.max_map_count=262144
progress_bar

# Actualizar los paquetes de apt
echo_message "🔄 Actualizando paquetes..."
run_command sudo apt-get update -y
progress_bar

# Instalar dependencias
echo_message "📦 Instalando dependencias..."
run_command sudo apt-get install -y ca-certificates curl lsb-release
progress_bar

# Agregar la clave GPG oficial de Docker
echo_message "🔑 Agregando la clave GPG de Docker..."
run_command sudo install -m 0755 -d /etc/apt/keyrings
run_command sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
run_command sudo chmod a+r /etc/apt/keyrings/docker.asc
progress_bar

# Agregar el repositorio de Docker
echo_message "📋 Agregando repositorio de Docker..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 2>&1
progress_bar

# Actualizar los repositorios
echo_message "🔄 Actualizando repositorios..."
run_command sudo apt-get update
progress_bar

# Instalar Docker y Docker Compose
echo_message "🐳 Instalando Docker y Docker Compose..."
run_command sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
progress_bar

# Verificar la instalación de Docker
echo_message "✅ Verificando instalación de Docker..."
docker --version
progress_bar

# Verificar la instalación de Docker Compose
echo_message "✅ Verificando instalación de Docker Compose..."
docker compose version
progress_bar

# Usar Docker sin sudo
echo_message "🔧 Configurando Docker para no usar sudo..."
run_command sudo groupadd docker
progress_bar
echo_message "👤 Agregando usuario al grupo Docker..."
run_command sudo usermod -aG docker vagrant
progress_bar
echo_message "🔄 Aplicando cambios de grupo..."
run_command newgrp docker
progress_bar

# Clonar el repositorio de GitHub
echo_message "📂 Clonando el repositorio..."
run_command git clone https://github.com/fcongedo/jenkins-prometheus-grafana-sonarqube.git
progress_bar

# Navegar al directorio del repositorio clonado
cd jenkins-prometheus-grafana-sonarqube

# Construir las imágenes Docker
echo_message "⚙️  Construyendo imágenes Docker..."
run_command docker network create back-tier || true
run_command sudo docker compose build --pull --no-cache
progress_bar

# Iniciar los contenedores Docker
echo_message "🚀 Iniciando contenedores Docker..."
run_command sudo docker compose up --detach
progress_bar

# Esperar a que los contenedores estén en marcha
sleep 10

# Mostrar las URLs HTTP de los contenedores relevantes
echo_message "${CYAN}🌐 Servicios en Contenedores Docker:${NC}"
docker ps --format "table {{.Names}}\t{{.Ports}}" | grep -E "(8080|9090|3000|9001)" | while read line
do
    CONTAINER_NAME=$(echo $line | awk '{print $1}')
    CONTAINER_PORT=$(echo $line | awk '{print $2}' | cut -d':' -f2)
    echo -e "${YELLOW}$CONTAINER_NAME${NC}    http://localhost:$CONTAINER_PORT/ 🚀"
done
