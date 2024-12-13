#!groovy

import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

// Configurar credenciales de usuario
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "admin")
instance.setSecurityRealm(hudsonRealm)

// Configurar autorización de acceso
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)

// Deshabilitar el Setup Wizard
instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)
instance.save()

println "--> Configuración inicial de Jenkins completada"
