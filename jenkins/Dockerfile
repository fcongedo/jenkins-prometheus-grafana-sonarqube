FROM jenkins/jenkins:lts

# Cambiar a usuario root para instalar paquetes y configurar sudo
USER root

# Instalar sudo, Docker, Java 17 y Maven 3.9.9
RUN apt-get update && \
    apt-get install -y sudo docker.io openjdk-17-jdk wget && \
    apt-get clean

# Instalar Maven 3.9.9
RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz && \
    tar -xvzf apache-maven-3.9.9-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-3.9.9 /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/bin/mvn && \
    rm apache-maven-3.9.9-bin.tar.gz

# Configurar sudo para que no requiera contraseña para el usuario Jenkins
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Verificar si el grupo docker existe y agregar al usuario Jenkins
RUN getent group docker || groupadd -g 999 docker && usermod -aG docker jenkins

# Configurar variables de entorno para Java y Maven
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH
ENV M2_HOME=/opt/maven
ENV PATH=$M2_HOME/bin:$PATH

# Copiar el archivo plugins.txt con la lista de plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# Instalar los plugins de Jenkins usando jenkins-plugin-cli
RUN jenkins-plugin-cli --plugins -f /usr/share/jenkins/ref/plugins.txt

# Deshabilitar el Setup Wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Copiar el script Groovy para inicializar Jenkins con credenciales predeterminadas
COPY basic-security.groovy /usr/share/jenkins/ref/init.groovy.d/basic-security.groovy

# Volver al usuario Jenkins por defecto
USER jenkins
