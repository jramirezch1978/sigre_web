package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class LineaConformidadResponse {
    private Long ordenServicioId;
    private String nroOs;
    private Long lineaId;
    private Integer nroItem;
    private Long servicioId;
    private String servicioCodigo;
    private String descripcion;
    private BigDecimal importe;
    private BigDecimal subtotal;
    private LocalDate fecProyect;
    private OffsetDateTime conformidadFecha;
    private Long conformidadUsr;
    private String conformidadUsrNombre;
    private String proveedorNombre;
    private String flagEstado;
}
