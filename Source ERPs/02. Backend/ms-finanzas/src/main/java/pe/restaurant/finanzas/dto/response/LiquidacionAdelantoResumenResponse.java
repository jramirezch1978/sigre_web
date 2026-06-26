package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Fila ligera del listado de liquidaciones de adelanto (HU-FIN-ADL-003), pensada para el
 * filtro por Tipo de Adelanto. Solo expone datos de la propia entidad + etiquetas derivadas
 * para evitar consultas N+1 (no resuelve monto del adelanto ni total gastado por fila).
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LiquidacionAdelantoResumenResponse {

    private Long id;
    private Long solicitudGiroId;
    private String nroLiquidacion;
    private String tipoAdelanto;
    private String tipoAdelantoLabel;
    private Long proveedorId;
    private Long monedaId;
    private Long sucursalId;
    private BigDecimal importeNeto;
    private BigDecimal saldo;
    private String flagEstado;
    private String estadoLabel;
    private LocalDate fechaRegistro;
    private LocalDate fechaLiquidacion;
}
