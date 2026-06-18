package pe.restaurant.contabilidad.dto.response;

import lombok.Builder;
import lombok.Getter;

import java.time.Instant;
import java.util.List;

@Getter
@Builder
public class MatrizContableResponse {

    private final Long id;
    private final Long grupoMatrizCntblId;
    private final String codigo;
    private final String descripcion;
    private final String flagEstado;
    private final Long createdBy;
    private final Instant fecCreacion;
    private final Long updatedBy;
    private final Instant fecModificacion;
    private final List<MatrizContableDetResponse> detalles;
}
