package com.sigre.finanzas.specification;

import org.springframework.data.jpa.domain.Specification;
import com.sigre.finanzas.entity.CajaBancos;

import java.time.LocalDate;

public class CajaBancosSpecification {

    public static Specification<CajaBancos> conFlagTipoTransaccion(String flagTipoTransaccion) {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.equal(root.get("flagTipoTransaccion"), flagTipoTransaccion);
    }

    public static Specification<CajaBancos> conBancoCntaId(Long bancoCntaId) {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.equal(root.get("bancoCntaId"), bancoCntaId);
    }

    public static Specification<CajaBancos> conFechaEmisionDesde(LocalDate fechaDesde) {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.greaterThanOrEqualTo(root.get("fechaEmision"), fechaDesde);
    }

    public static Specification<CajaBancos> conFechaEmisionHasta(LocalDate fechaHasta) {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.lessThanOrEqualTo(root.get("fechaEmision"), fechaHasta);
    }

    public static Specification<CajaBancos> conEstado(String estado) {
        return (root, query, criteriaBuilder) -> {
            if ("REGISTRADO".equals(estado)) {
                return criteriaBuilder.and(
                    criteriaBuilder.equal(root.get("flagEstado"), "1"),
                    criteriaBuilder.isNull(root.get("fechaEjecucion"))
                );
            } else if ("EJECUTADO".equals(estado)) {
                return criteriaBuilder.and(
                    criteriaBuilder.equal(root.get("flagEstado"), "1"),
                    criteriaBuilder.isNotNull(root.get("fechaEjecucion"))
                );
            } else if ("ANULADO".equals(estado)) {
                return criteriaBuilder.equal(root.get("flagEstado"), "0");
            }
            return criteriaBuilder.conjunction();
        };
    }

    public static Specification<CajaBancos> conEntidadContribuyenteId(Long entidadContribuyenteId) {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.equal(root.get("entidadContribuyenteId"), entidadContribuyenteId);
    }
}
