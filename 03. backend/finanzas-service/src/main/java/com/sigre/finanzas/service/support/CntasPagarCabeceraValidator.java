package com.sigre.finanzas.service.support;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import com.sigre.common.exception.BusinessException;
import com.sigre.finanzas.service.FinanzasErrorCodes;

@Component
public class CntasPagarCabeceraValidator {

    @PersistenceContext
    private EntityManager entityManager;

    public void validar(Integer ano, Integer mes, Long cntblLibroId) {
        validarPeriodoContable(ano, mes);
        validarCntblLibro(cntblLibroId);
    }

    private void validarPeriodoContable(Integer ano, Integer mes) {
        if (ano == null || mes == null) {
            throw new BusinessException(
                    "El año y mes del periodo contable son obligatorios",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    FinanzasErrorCodes.PERIODO_CONTABLE_INVALIDO);
        }
        if (ano < 1900 || mes < 1 || mes > 12) {
            throw new BusinessException(
                    "Periodo contable inválido",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    FinanzasErrorCodes.PERIODO_CONTABLE_INVALIDO);
        }
    }

    private void validarCntblLibro(Long cntblLibroId) {
        if (cntblLibroId == null || cntblLibroId <= 0) {
            throw new BusinessException(
                    "El libro contable (cntbl_libro_id) es obligatorio",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    FinanzasErrorCodes.LIBRO_CONTABLE_NO_ENCONTRADO);
        }
        Number count = (Number) entityManager.createNativeQuery(
                        "SELECT COUNT(*) FROM contabilidad.cntbl_libro WHERE id = :id")
                .setParameter("id", cntblLibroId)
                .getSingleResult();
        if (count.longValue() == 0) {
            throw new BusinessException(
                    "Libro contable no encontrado",
                    HttpStatus.NOT_FOUND,
                    FinanzasErrorCodes.LIBRO_CONTABLE_NO_ENCONTRADO);
        }
    }
}
