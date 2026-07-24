package com.sigre.common.maestro;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

/**
 * Aplica sort ASC por unique key de negocio cuando el {@link Pageable}/{@link Sort} llega sin orden.
 */
public final class UniqueKeyPageables {

    private static final BusinessUniqueKeyResolver RESOLVER = new DefaultBusinessUniqueKeyResolver();

    private UniqueKeyPageables() {
    }

    public static Pageable ensure(Class<?> entityClass, Pageable pageable) {
        if (pageable == null || pageable.isUnpaged()) {
            return pageable;
        }
        if (pageable.getSort().isSorted()) {
            return pageable;
        }
        return RESOLVER.resolveProperty(entityClass)
                .map(property -> (Pageable) PageRequest.of(
                        pageable.getPageNumber(),
                        pageable.getPageSize(),
                        Sort.by(Sort.Direction.ASC, property)))
                .orElse(pageable);
    }

    public static Sort ensure(Class<?> entityClass, Sort sort) {
        if (sort != null && sort.isSorted()) {
            return sort;
        }
        return RESOLVER.resolveProperty(entityClass)
                .map(property -> Sort.by(Sort.Direction.ASC, property))
                .orElse(sort == null ? Sort.unsorted() : sort);
    }

    public static Sort sortOf(Class<?> entityClass) {
        return ensure(entityClass, Sort.unsorted());
    }

    static BusinessUniqueKeyResolver resolver() {
        return RESOLVER;
    }
}
