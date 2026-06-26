package pe.restaurant.common.event;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * Evento de pre-asiento contable.
 * Enviado por todos los módulos operativos hacia ms-contabilidad vía RabbitMQ.
 */
@Data
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class PreAsientoEvent extends BaseEvent {

    private String tipoDocumento;
    private String numeroDocumento;
    private LocalDate fechaContable;
    private String glosa;
    private String monedaCodigo;
    private BigDecimal tipoCambio;

    private List<LineaPreAsiento> lineas;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LineaPreAsiento {
        private String cuentaContableCodigo;
        private String centroCostoCodigo;
        private BigDecimal debe;
        private BigDecimal haber;
        private String glosaDetalle;
    }
}
