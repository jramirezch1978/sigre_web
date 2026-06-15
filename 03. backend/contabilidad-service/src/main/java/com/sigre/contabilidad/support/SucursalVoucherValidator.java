package com.sigre.contabilidad.support;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import com.sigre.common.exception.BusinessException;
import com.sigre.contabilidad.service.ContabilidadErrorCodes;

/**
 * Valida que la sucursal del request exista y tenga código para el voucher.
 * El prefijo SS del voucher lo resuelve {@code contabilidad.fn_get_voucher_number}
 * consultando {@code auth.sucursal.codigo} a partir del {@code sucursal_id}.
 */
@Component
public class SucursalVoucherValidator {

    @PersistenceContext
    private EntityManager entityManager;

    public Long validar(Long sucursalId) {
        if (sucursalId == null || sucursalId <= 0) {
            throw new BusinessException(
                    "La sucursal es obligatoria para generar el voucher",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    ContabilidadErrorCodes.SUCURSAL_NO_ENCONTRADA);
        }

        try {
            String codigo = (String) entityManager.createNativeQuery(
                            "SELECT TRIM(codigo) FROM auth.sucursal WHERE id = :id")
                    .setParameter("id", sucursalId)
                    .getSingleResult();

            if (codigo == null || codigo.isBlank()) {
                throw new BusinessException(
                        "La sucursal no tiene código asignado (requerido para el voucher)",
                        HttpStatus.UNPROCESSABLE_ENTITY,
                        ContabilidadErrorCodes.SUCURSAL_SIN_CODIGO);
            }
        } catch (BusinessException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new BusinessException(
                    "Sucursal no encontrada",
                    HttpStatus.NOT_FOUND,
                    ContabilidadErrorCodes.SUCURSAL_NO_ENCONTRADA);
        }

        return sucursalId;
    }
}
