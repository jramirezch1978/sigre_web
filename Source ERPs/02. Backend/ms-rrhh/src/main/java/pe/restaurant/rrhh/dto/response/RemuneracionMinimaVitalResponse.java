package pe.restaurant.rrhh.dto.response;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Data
public class RemuneracionMinimaVitalResponse {

    private Long id;
    private Long tipoTrabajadorId;
    private String tipoTrabajadorCodigo;
    private String tipoTrabajadorNombre;
    private BigDecimal rmv;
    private LocalDate fechaDesde;
    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
