package pe.restaurant.compras.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * Request para recepción de OC con integración contable síncrona (Ruta B).
 * Extiende la recepción legacy agregando datos contables requeridos por ms-contabilidad.
 */
@Getter
@Setter
@NoArgsConstructor
public class OrdenCompraRecepcionContableRequest {

    @NotNull
    private Long articuloMovTipoId;

    @NotNull
    private Long almacenId;

    private LocalDate fechaMov;

    private String observaciones;

    @NotNull
    @Positive
    private Long cntblLibroId;

    private Long monedaId;

    private BigDecimal tipoCambio;

    private String glosa;

    @NotNull
    private List<LineaConcepto> lineas;

    @Getter
    @Setter
    @NoArgsConstructor
    public static class LineaConcepto {
        @NotNull
        private Long articuloId;

        @NotNull
        @Positive
        private BigDecimal cantidad;

        @NotNull
        @Positive
        private BigDecimal costoUnitario;

        @NotNull
        private Long conceptoFinancieroId;

        private Long centrosCostoId;
        private Long ocDetId;
    }
}
