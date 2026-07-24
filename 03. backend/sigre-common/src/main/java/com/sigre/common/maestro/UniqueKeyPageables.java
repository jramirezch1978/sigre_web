package com.sigre.common.maestro;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

/**
 * Aplica sort ASC por unique key de negocio cuando el {@link Pageable}/{@link Sort} llega sin orden.
 * <p>
 * Usar en:
 * <ul>
 *   <li>{@link BusinessUniqueKeyJpaRepository} (automático en {@code findAll})</li>
 *   <li>Consultas derivadas {@code findBy…(Pageable)}: {@code repo.findByX(x, UniqueKeyPageables.ensure(Entity.class, pageable))}</li>
 *   <li>Consultas que devuelven {@code List}: {@code repo.findByX(x, UniqueKeyPageables.sortOf(Entity.class))}</li>
 * </ul>
 */
public final class UniqueKeyPageables {

    private static final BusinessUniqueKeyResolver RESOLVER = new DefaultBusinessUniqueKeyResolver();

    private UniqueKeyPageables() {
    }

    public static Pageable ensure(Class<?> entityClass, Pageable pageable) {
        if (pageable == null) {
            return null;
        }
        if (pageable.getSort().isSorted()) {
            return pageable;
        }
        return RESOLVER.resolveProperty(entityClass)
                .map(property -> {
                    Sort sort = Sort.by(Sort.Direction.ASC, property);
                    if (pageable.isUnpaged()) {
                        return Pageable.unpaged(sort);
                    }
                    return (Pageable) PageRequest.of(pageable.getPageNumber(), pageable.getPageSize(), sort);
                })
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
