package com.sigre.common.maestro;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Marca el campo de negocio que debe usarse como criterio de orden por defecto
 * (unique key más cercano al PK: código, tipoMov, cencos, etc.).
 * <p>
 * Si no se declara, {@link BusinessUniqueKeyResolver} lo infiere desde metadatos JPA.
 */
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface BusinessUniqueKey {
}
