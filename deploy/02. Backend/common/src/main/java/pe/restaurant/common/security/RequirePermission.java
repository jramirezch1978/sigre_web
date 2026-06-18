package pe.restaurant.common.security;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Anotación para validar permisos granulares en endpoints.
 * Ejemplo: @RequirePermission(modulo = "COM", opcion = "OC", accion = "CREAR")
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface RequirePermission {
    String modulo();
    String opcion();
    String accion();
}
