package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

/**
 * Resultado consolidado de un cierre masivo de liquidaciones: total procesado,
 * cuántas se cerraron y el detalle por liquidación (éxito o motivo del fallo).
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CierreMasivoResultadoResponse {

    private int totalProcesadas;
    private int exitosas;
    private int fallidas;
    private List<Item> resultados = new ArrayList<>();

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Item {
        private Long liquidacionId;
        private boolean exito;
        private String mensaje;
    }
}
