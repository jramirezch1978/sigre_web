package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LiquidacionDetResponse {

    private Long id;

    private Long liquidacionId;

    private Integer item;

    private String origenDocRef;

    private Long monedaId;

    private Long conceptoFinancieroId;

    private Long cntasPagarId;

    private Long cntasCobrarId;

    private Long centrosCostoId;

    private Short factorSigno;

    private BigDecimal importe;

    private String flagRetencion;

    private BigDecimal importeRetenido;

    private String flagProvisionado;

    private String flagEstado;

    private Long createdBy;

    private Instant fecCreacion;

    private Long updatedBy;

    private Instant fecModificacion;
}
