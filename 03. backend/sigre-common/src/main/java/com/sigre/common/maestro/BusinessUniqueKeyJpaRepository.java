package com.sigre.common.maestro;

import jakarta.persistence.EntityManager;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.support.JpaEntityInformation;
import org.springframework.data.jpa.repository.support.SimpleJpaRepository;
import org.springframework.lang.Nullable;

import java.util.List;

/**
 * Repositorio base compartido: todos los {@code findAll} paginados/ordenados
 * heredan el sort por unique key de negocio cuando el cliente no envía {@code sort}.
 */
public class BusinessUniqueKeyJpaRepository<T, ID> extends SimpleJpaRepository<T, ID> {

    public BusinessUniqueKeyJpaRepository(JpaEntityInformation<T, ?> entityInformation, EntityManager entityManager) {
        super(entityInformation, entityManager);
    }

    public BusinessUniqueKeyJpaRepository(Class<T> domainClass, EntityManager entityManager) {
        super(domainClass, entityManager);
    }

    @Override
    public Page<T> findAll(Pageable pageable) {
        return super.findAll(UniqueKeyPageables.ensure(getDomainClass(), pageable));
    }

    @Override
    public Page<T> findAll(@Nullable Specification<T> spec, Pageable pageable) {
        return super.findAll(spec, UniqueKeyPageables.ensure(getDomainClass(), pageable));
    }

    @Override
    public List<T> findAll(Sort sort) {
        return super.findAll(UniqueKeyPageables.ensure(getDomainClass(), sort));
    }

    @Override
    public List<T> findAll(@Nullable Specification<T> spec, Sort sort) {
        return super.findAll(spec, UniqueKeyPageables.ensure(getDomainClass(), sort));
    }
}
