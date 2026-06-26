package pe.restaurant.almacen.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * Request del endpoint contable nuevo ({@code POST /api/almacen/movimientos/contable}, Ruta B).
 * <p>
 * Extiende la cabecera de movimiento estándar agregando los datos que exige ms-contabilidad para
 * generar el pre-asiento por concepto financiero ({@code cntblLibroId}, moneda, tipo de cambio, glosa).
 * El periodo contable ({@code ano}/{@code mes}) se deriva de {@code fechaMov}.
 * <p>
 * En este flujo, cada línea ({@link MovimientoLineaRequest#getConceptoFinancieroId()}) debe traer su
 * concepto financiero cuando el tipo de movimiento contabiliza.
 */
@Getter
@Setter
@NoArgsConstructor
public class MovimientoContableCabeceraRequest extends MovimientoCabeceraRequest {

    /** Libro contable destino del pre-asiento (cntbl_libro_id). Obligatorio. */
    @NotNull
    @Positive
    private Long cntblLibroId;

    /** Moneda del asiento. Si es null, ms-contabilidad asume la moneda funcional. */
    private Long monedaId;

    /** Tipo de cambio para la conversión a moneda extranjera (opcional). */
    private BigDecimal tipoCambio;

    /** Glosa de cabecera del pre-asiento (opcional; ms-contabilidad genera una por defecto). */
    private String glosa;
}
