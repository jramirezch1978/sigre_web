package pe.restaurant.contabilidad.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CntblTipoDetraccionResponse {

    private Long id;
    private String codigo;
    private String descripcion;
    private BigDecimal porcentaje;
    private Long planContableDetId;
    private LocalDate vigenciaDesde;
    private LocalDate vigenciaHasta;
    private String flagEstado;
}
