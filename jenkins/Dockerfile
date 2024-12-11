# Utiliza la última versión de Jenkins LTS
FROM jenkins/jenkins:lts

# Establecer las variables de entorno para deshabilitar el asistente de configuración y establecer el usuario y contraseña predeterminados
#ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
#ENV JENKINS_USER=admin
#ENV JENKINS_PASS=admin

# Copiar lista de plugins y proceder con la instalación usando jenkins-plugin-cli
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/plugins.txt

# Cambiar al usuario root para poder instalar dependencias necesarias
USER root

# Actualizar y agregar dependencias necesarias para Docker (sin instalar Docker en el contenedor)
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    lsb-release \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Añadir la clave GPG de Docker (aunque no instalarás Docker aquí, es útil para Jenkins ejecutar otros comandos de Docker)
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Añadir repositorio de Docker
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Cambiar de vuelta al usuario Jenkins para seguridad
USER jenkins

# Exponer el puerto de Jenkins
EXPOSE 8080

# Comando de inicio por defecto para Jenkins
CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]
