package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

/**
 * Resultado consolidado de una operación masiva (aprobar / anular) sobre Órdenes de Giro:
 * total procesado, cuántas tuvieron éxito y el detalle por orden (éxito o motivo del fallo).
 * Sigue el mismo patrón que {@code CierreMasivoResultadoResponse}.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class OperacionMasivaGiroResultadoResponse {

    private int totalProcesadas;
    private int exitosas;
    private int fallidas;
    private List<Item> resultados = new ArrayList<>();

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Item {
        private Long ordenGiroId;
        private boolean exito;
        private String mensaje;
    }
}
