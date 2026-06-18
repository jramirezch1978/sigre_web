package pe.restaurant.ventas.support;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.ventas.entity.CuentaCobrar;
import pe.restaurant.ventas.service.VentasErrorCodes;

@Component
public class CuentaCobrarCabeceraValidator {

    @PersistenceContext
    private EntityManager entityManager;

    public void validar(Integer ano, Integer mes, Long cntblLibroId) {
        validarPeriodoContable(ano, mes);
        validarCntblLibro(cntblLibroId);
    }

    public void copiarPeriodoContable(CuentaCobrar destino, CuentaCobrar origen) {
        destino.setAno(origen.getAno());
        destino.setMes(origen.getMes());
        destino.setCntblLibroId(origen.getCntblLibroId());
    }

    private void validarPeriodoContable(Integer ano, Integer mes) {
        if (ano == null || mes == null) {
            throw new BusinessException(
                    "El año y mes del periodo contable son obligatorios",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    VentasErrorCodes.CXC_PERIODO_INVALIDO);
        }
        if (ano < 1900 || mes < 1 || mes > 12) {
            throw new BusinessException(
                    "Periodo contable inválido",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    VentasErrorCodes.CXC_PERIODO_INVALIDO);
        }
    }

    private void validarCntblLibro(Long cntblLibroId) {
        if (cntblLibroId == null || cntblLibroId <= 0) {
            throw new BusinessException(
                    "El libro contable (cntbl_libro_id) es obligatorio",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    VentasErrorCodes.CXC_LIBRO_NO_ENCONTRADO);
        }
        Number count = (Number) entityManager.createNativeQuery(
                        "SELECT COUNT(*) FROM contabilidad.cntbl_libro WHERE id = :id")
                .setParameter("id", cntblLibroId)
                .getSingleResult();
        if (count.longValue() == 0) {
            throw new BusinessException(
                    "Libro contable no encontrado",
                    HttpStatus.NOT_FOUND,
                    VentasErrorCodes.CXC_LIBRO_NO_ENCONTRADO);
        }
    }
}
