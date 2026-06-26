package pe.restaurant.contabilidad.support;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.contabilidad.repository.CntblLibroRepository;
import pe.restaurant.contabilidad.service.ContabilidadErrorCodes;

@Component
@RequiredArgsConstructor
public class AsientoPeriodoLibroValidator {

    private final CntblLibroRepository libroRepository;

    public PeriodoLibro validar(Integer ano, Integer mes, Long cntblLibroId) {
        if (ano == null || mes == null) {
            throw new BusinessException(
                    "El año y mes del periodo contable son obligatorios",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    ContabilidadErrorCodes.PERIODO_CONTABLE_INVALIDO);
        }
        if (ano < 1900 || mes < 1 || mes > 12) {
            throw new BusinessException(
                    "Periodo contable inválido",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    ContabilidadErrorCodes.PERIODO_CONTABLE_INVALIDO);
        }
        if (cntblLibroId == null || cntblLibroId <= 0) {
            throw new BusinessException(
                    "El libro contable (cntbl_libro_id) es obligatorio",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    ContabilidadErrorCodes.LIBRO_CONTABLE_NO_ENCONTRADO);
        }
        libroRepository.findById(cntblLibroId)
                .orElseThrow(() -> new BusinessException(
                        "Libro contable no encontrado",
                        HttpStatus.NOT_FOUND,
                        ContabilidadErrorCodes.LIBRO_CONTABLE_NO_ENCONTRADO));
        return new PeriodoLibro(ano, mes, cntblLibroId);
    }

    public record PeriodoLibro(int ano, int mes, long cntblLibroId) {
    }
}
