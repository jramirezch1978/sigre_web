package com.sigre.common.maestro;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Opt-out: la entidad no recibe sort automático por unique key de negocio
 * (p. ej. transacciones cuyo listado debe ordenarse por fecha vía sort del controller).
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Inherited
@Documented
public @interface NoDefaultBusinessSort {
}
