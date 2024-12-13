#!/bin/bash
SONAR_URL="http://localhost:9000"
ADMIN_USER="admin"
ADMIN_PASS="admin"

# Esperar a que SonarQube esté listo
until $(curl --output /dev/null --silent --head --fail "$SONAR_URL/api/system/status"); do
    echo "Esperando a que SonarQube esté listo..."
    sleep 5
done

# Generar un token para Jenkins
echo "Generando token para Jenkins..."
curl -u "$ADMIN_USER:$ADMIN_PASS" -X POST "$SONAR_URL/api/user_tokens/generate" \
    -d "name=jenkins-token"

echo "Inicialización de SonarQube completada."
