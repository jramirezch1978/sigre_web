package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrdenServicioLineaResponse {

    private Long id;
    private Integer nroItem;
    private Long servicioId;
    private String servicioCodigo;
    private String servicioDescripcion;
    private String descripcion;
    private LocalDate fecProyect;
    private BigDecimal importe;
    private BigDecimal dsctoPorcentaje;
    private BigDecimal decuento;
    private Long tiposImpuestoId;
    private BigDecimal impuesto;
    private Long tiposImpuesto2Id;
    private BigDecimal impuesto2;
    private BigDecimal subtotal;
    private BigDecimal impProvisionado;
    private Long centrosCostoId;
    private Long conceptoFinancieroId;
    private Long operacionesDetId;
    private OffsetDateTime conformidadFecha;
    private Long conformidadUsr;
    private String conformidadUsrNombre;
    private String flagEstado;
}
