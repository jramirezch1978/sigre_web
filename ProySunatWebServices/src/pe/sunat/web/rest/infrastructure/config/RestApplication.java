package pe.sunat.web.rest.infrastructure.config;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

import pe.sunat.web.rest.infrastructure.controller.AuthController;
import pe.sunat.web.rest.infrastructure.controller.RucController;

/**
 * Configuracion de la aplicacion JAX-RS
 * Define el path base /api para todos los endpoints REST
 * 
 * Compatible con JAX-RS 1.x (RESTEasy 2.x en JBoss 7.1.1)
 */
@ApplicationPath("/api")
public class RestApplication extends Application {
    
    private Set<Class<?>> classes = new HashSet<Class<?>>();
    
    public RestApplication() {
        // Registrar controladores REST
        classes.add(AuthController.class);
        classes.add(RucController.class);
    }
    
    @Override
    public Set<Class<?>> getClasses() {
        return classes;
    }
}
