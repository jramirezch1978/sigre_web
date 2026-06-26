package pe.restaurant.rrhh.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ConceptoPlanillaResponse {

    private Long id;
    private String codigo;
    private String nombre;
    private String descripcionBreve;
    private BigDecimal factorPago;
    private BigDecimal importeTopeMin;
    private BigDecimal importeTopeMax;
    private BigDecimal numeroHoras;
    private String grupoCalculo;
    private String flagReplicacion;
    private String conceptoRtps;
    private String flagSubsidio;
    private String flagReporteQuinta;
    private String numeroOrden;
    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
