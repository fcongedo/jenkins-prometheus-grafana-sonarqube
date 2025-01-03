FROM sonarqube:community

# Cambiar a root para realizar configuraciones
USER root

# Establecer la variable de entorno para evitar configuraciones interactivas
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar los repositorios e instalar dependencias sin interacción
RUN apt-get update && \
    apt-get install -y jq curl sudo && \
    apt-get clean

# Permitir que el usuario sonarqube ejecute sudo sin contraseña
RUN echo "sonarqube ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sonarqube && \
    chmod 0440 /etc/sudoers.d/sonarqube

# Copiar los scripts de configuración y arranque al contenedor
COPY configure_sonarqube.sh /usr/local/bin/configure_sonarqube.sh
COPY start.sh /usr/local/bin/start.sh

# Dar permisos de ejecución a los scripts
RUN chmod +x /usr/local/bin/configure_sonarqube.sh /usr/local/bin/start.sh

# Volver al usuario sonarqube para evitar correr procesos como root
USER sonarqube

# Usar el script start.sh como ENTRYPOINT
CMD ["/bin/bash", "/usr/local/bin/start.sh"]