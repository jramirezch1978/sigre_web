package pe.restaurant.compras.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
public class OrdenServicioLineaRequest {

    private Long id;

    @NotNull
    private Long servicioId;

    private String descripcion;

    @NotNull
    private LocalDate fecProyect;

    @NotNull
    @DecimalMin("0.0001")
    private BigDecimal importe;

    private BigDecimal dsctoPorcentaje;

    private Long tiposImpuestoId;

    private Long tiposImpuesto2Id;

    private Long centrosCostoId;

    private Long conceptoFinancieroId;

    private Long operacionesDetId;
}
