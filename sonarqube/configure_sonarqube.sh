#!/bin/bash

SONAR_URL="http://localhost:9000"
OLD_PASSWORD="admin"
NEW_PASSWORD="administrator"
#TOKEN_NAME="jenkins-token"
USERNAME="admin"

echo "Esperando a que SonarQube esté disponible en $SONAR_URL ..."
until curl -s "$SONAR_URL/api/system/status" | grep -q "UP"; do
  echo "SonarQube aún no está disponible. Esperando..."
  sleep 5
done

echo "SonarQube está disponible. Procediendo con la configuración."

# Cambiar la contraseña inicial
curl -X POST -u "$USERNAME:$OLD_PASSWORD" \
  "$SONAR_URL/api/users/change_password" \
  -d "login=$USERNAME&password=$NEW_PASSWORD&previousPassword=$OLD_PASSWORD"
