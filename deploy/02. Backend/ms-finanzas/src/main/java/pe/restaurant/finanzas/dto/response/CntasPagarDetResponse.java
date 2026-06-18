package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CntasPagarDetResponse {

    private Long id;
    private Long cntasPagarId;
    private Integer item;
    private Long conceptoFinancieroId;
    private String descripcion;
    private Long articuloId;
    private BigDecimal cantidad;
    private BigDecimal precioUnitario;
    private BigDecimal monto;
    private Long centrosCostoId;
    private List<DetImpuestoResponse> impuestos;
    private Long ordenCompraDetId;
    private Long ordenServicioDetId;
    private Long valeMovDetId;
    private Long sucursalRefId;
    private Long docTipoRefId;
    private String nroRef;
    private Integer itemRef;
    private LocalDate fecMovilidad;
    private String movDesde;
    private String movHasta;
    private Long trabajadorId;
    private LocalDate fechaMov;
    private String tipoMov;
    private String referencia;
    private String flagEstado;
    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
