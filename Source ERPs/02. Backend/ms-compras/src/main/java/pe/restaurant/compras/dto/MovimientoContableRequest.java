package pe.restaurant.compras.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * DTO para llamar a POST /api/almacen/movimientos/contable (Ruta B).
 * Duplicado de MovimientoContableCabeceraRequest en ms-almacen.
 */
@Getter
@Setter
@NoArgsConstructor
public class MovimientoContableRequest {

    private Long sucursalId;
    private Long almacenId;
    private Long articuloMovTipoId;
    private LocalDate fechaMov;
    private Long proveedorId;
    private Long ordenCompraId;
    private String observaciones;
    private Long cntblLibroId;
    private Long monedaId;
    private BigDecimal tipoCambio;
    private String glosa;
    private List<MovimientoLineaContable> lineas;

    @Getter
    @Setter
    @NoArgsConstructor
    public static class MovimientoLineaContable {
        private Long articuloId;
        private BigDecimal cantProcesada;
        private BigDecimal costoUnitario;
        private Long conceptoFinancieroId;
        private Long centrosCostoId;
        private Long ocDetId;
    }
}
