package pe.restaurant.worker.client.dto;

import lombok.Data;

@Data
public class ActivosJobEjecucionResponse {
    private String job;
    private Integer anio;
    private Integer mes;
    private int procesados;
    private int contabilizados;
}
