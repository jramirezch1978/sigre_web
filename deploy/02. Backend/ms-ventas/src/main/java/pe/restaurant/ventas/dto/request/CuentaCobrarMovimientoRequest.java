package pe.restaurant.ventas.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.restaurant.ventas.entity.CuentaCobrarDet;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CuentaCobrarMovimientoRequest {

    @NotNull
    private LocalDate fechaMov;

    @NotNull
    private CuentaCobrarDet.TipoMovimiento tipoMov;

    @NotNull
    private BigDecimal monto;

    private String referencia;

    @NotNull(message = "El concepto financiero es obligatorio")
    private Long conceptoFinancieroId;

    @NotNull(message = "El número de ítem es obligatorio")
    private Integer nroItem;

    private String descripcion;

    private Long creditoFiscalId;

    private BigDecimal cantidad;

    private BigDecimal precioUnitario;

    private List<DetImpuestoRequest> impuestos;
}

