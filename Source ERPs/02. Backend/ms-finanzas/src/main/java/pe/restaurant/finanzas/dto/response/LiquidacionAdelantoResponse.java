package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * Vista enriquecida de una liquidación de adelanto (HU-FIN-ADL-003). Agrega, sobre el
 * detalle base, los campos calculados/derivados que pide la HU y que no viven como columnas:
 * Tipo de Adelanto legible, beneficiario, monto del adelanto, Total Gastado y el Saldo a
 * Devolver / Regularizar en tiempo real. Todo se calcula en lectura; no requiere BD nueva.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LiquidacionAdelantoResponse {

    /** Código persistido en tipo_liquidacion: P / C. */
    private String tipoAdelanto;

    /** Etiqueta legible: "Proveedor" / "Colaborador". */
    private String tipoAdelantoLabel;

    /** PROVEEDOR o COLABORADOR. */
    private String beneficiarioTipo;

    /** Proveedor (si P) o solicitante de la solicitud de giro (si C). */
    private Long beneficiarioId;

    /**
     * Razón Social (solo lectura, HU-FIN-ADL-003). Se resuelve desde maestros: para un adelanto
     * de Proveedor es la razón social del proveedor (relaciones-comerciales). Para Colaborador
     * queda null (el beneficiario es una persona de RRHH, sin maestro de razón social).
     */
    private String razonSocial;

    /** Id del País de la sucursal de la liquidación. */
    private Long paisId;

    /** País (solo lectura, HU-FIN-ADL-003): nombre del país de la sucursal. */
    private String pais;

    /** Estado legible: Borrador / Pendiente / Aprobada / Rechazada / Observada / Cerrada / Anulada. */
    private String estadoLabel;

    /** Monto del adelanto (de la solicitud de giro vinculada). */
    private BigDecimal montoAdelanto;

    /** Total Gastado = suma de los detalles de la liquidación. */
    private BigDecimal totalGastado;

    /** Saldo a Devolver (>= 0): adelanto - total gastado, cuando el gasto es menor al adelanto. */
    private BigDecimal saldoDevolver;

    /** Saldo a Regularizar (>= 0): total gastado - adelanto, cuando el gasto excede el adelanto. */
    private BigDecimal saldoRegularizar;

    /** Detalle contable base de la liquidación (cabecera + líneas). */
    private LiquidacionDetalleResponse liquidacion;
}
