FROM jenkins/jenkins:lts

# Cambiar a usuario root para poder instalar sudo
USER root

# Instalar sudo
RUN apt-get update && apt-get install -y sudo

# Volver a cambiar al usuario jenkins por defecto
USER jenkins
