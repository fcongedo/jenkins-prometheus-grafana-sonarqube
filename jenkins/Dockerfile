FROM jenkins/jenkins:lts

# Cambiar a usuario root para instalar paquetes y configurar sudo
USER root

# Instalar sudo y Docker
RUN apt-get update && apt-get install -y sudo docker.io

# Configurar sudo para que no requiera contraseña para el usuario Jenkins
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Verificar si el grupo docker existe y agregar al usuario Jenkins
RUN getent group docker || groupadd -g 999 docker && usermod -aG docker jenkins

# Volver al usuario jenkins por defecto
USER jenkins