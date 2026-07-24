package com.sigre.common.maestro;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.aop.support.AopUtils;
import org.springframework.core.ResolvableType;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.Repository;
import org.springframework.stereotype.Component;

/**
 * Cubre métodos derivados del repositorio ({@code findBy…(Pageable)}) que no pasan
 * por {@link BusinessUniqueKeyJpaRepository#findAll(Pageable)}.
 */
@Aspect
@Component
public class BusinessUniqueKeyPageableAspect {

    @Around("execution(* com.sigre..repository..*(..)) && args(.., pageable)")
    public Object ensureUniqueKeySort(ProceedingJoinPoint joinPoint, Pageable pageable) throws Throwable {
        Class<?> domainClass = resolveDomainClass(joinPoint.getTarget(), joinPoint.getThis());
        if (domainClass == null) {
            return joinPoint.proceed();
        }

        Pageable ensured = UniqueKeyPageables.ensure(domainClass, pageable);
        if (ensured == pageable) {
            return joinPoint.proceed();
        }

        Object[] args = joinPoint.getArgs();
        for (int i = args.length - 1; i >= 0; i--) {
            if (args[i] instanceof Pageable) {
                args[i] = ensured;
                break;
            }
        }
        return joinPoint.proceed(args);
    }

    static Class<?> resolveDomainClass(Object target, Object proxy) {
        Object bean = target != null ? target : proxy;
        if (bean == null) {
            return null;
        }
        Class<?> userClass = AopUtils.getTargetClass(bean);
        for (Class<?> iface : userClass.getInterfaces()) {
            Class<?> domain = domainFromRepositoryInterface(iface);
            if (domain != null) {
                return domain;
            }
        }
        for (Class<?> iface : bean.getClass().getInterfaces()) {
            Class<?> domain = domainFromRepositoryInterface(iface);
            if (domain != null) {
                return domain;
            }
        }
        return null;
    }

    private static Class<?> domainFromRepositoryInterface(Class<?> iface) {
        if (!Repository.class.isAssignableFrom(iface)) {
            return null;
        }
        return ResolvableType.forClass(iface).as(Repository.class).getGeneric(0).resolve();
    }
}
