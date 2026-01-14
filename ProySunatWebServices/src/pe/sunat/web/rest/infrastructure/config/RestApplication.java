package pe.sunat.web.rest.infrastructure.config;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

import pe.sunat.web.rest.infrastructure.controller.AuthController;
import pe.sunat.web.rest.infrastructure.controller.RucController;

/**
 * Configuracion de la aplicacion JAX-RS
 * Base path: /api
 */
@ApplicationPath("/api")
public class RestApplication extends Application {
    
    @Override
    public Set<Class<?>> getClasses() {
        Set<Class<?>> classes = new HashSet<Class<?>>();
        
        // Registrar controladores
        classes.add(AuthController.class);
        classes.add(RucController.class);
        
        // Registrar filtro CORS
        classes.add(CorsFilter.class);
        
        return classes;
    }
}
