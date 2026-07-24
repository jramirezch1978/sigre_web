package com.sigre.common.maestro;

import java.util.Optional;

/**
 * Resuelve la propiedad de ordenamiento por unique key de negocio de una entidad.
 */
@FunctionalInterface
public interface BusinessUniqueKeyResolver {

    Optional<String> resolveProperty(Class<?> entityClass);
}
