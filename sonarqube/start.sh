#!/bin/bash

# Ejecuta el entrypoint original de SonarQube
/opt/sonarqube/docker/entrypoint.sh &

# Ejecuta el script de configuración una vez SonarQube esté listo (ya gestionado dentro de configure_sonarqube.sh)
echo "Ejecutando la configuración de SonarQube..."
/usr/local/bin/configure_sonarqube.sh

# Mantener el contenedor en ejecución
tail -f /dev/null