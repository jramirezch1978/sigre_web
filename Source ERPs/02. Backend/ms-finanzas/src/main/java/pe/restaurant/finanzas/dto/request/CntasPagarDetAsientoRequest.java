package pe.restaurant.finanzas.dto.request;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@Builder
public class CntasPagarDetAsientoRequest {

    private Long id;
    private Integer item;
    private Long conceptoFinancieroId;
    private String descripcion;
    private Long articuloId;
    private BigDecimal cantidad;
    private BigDecimal precioUnitario;
    private BigDecimal monto;
    private Long centrosCostoId;
    private List<DetImpuestoRequest> impuestos;
    private LocalDate fechaMov;
    private String tipoMov;
    private String referencia;
    private String glosa;
}
