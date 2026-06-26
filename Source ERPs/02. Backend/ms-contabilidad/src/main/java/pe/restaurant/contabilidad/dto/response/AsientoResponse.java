package pe.restaurant.contabilidad.dto.response;

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
public class AsientoResponse {

    private Long id;
    private String voucher;
    private Long libroId;
    private LocalDate fecha;
    private String glosa;
    private String naturalezaAsiento;
    private String moduloOrigen;
    private Long cntblPreasientoId;
    private String flagEstado;
    private Long monedaId;
    private BigDecimal tasaCambio;
    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
    private List<AsientoDetalleResponse> detalles;
}
