package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProgramacionPagoDetalleResponse {

    private Long id;

    private Long programacionId;

    private Long cntasPagarId;

    private String proveedorRazonSocial;

    private String docTipoCodigo;

    private String serie;

    private String numero;

    private BigDecimal totalCxP;

    private BigDecimal saldoCxP;

    private BigDecimal montoProgramado;

    private String flagEstado;

    private Long createdBy;

    private Instant fecCreacion;

    private Long updatedBy;

    private Instant fecModificacion;
}
