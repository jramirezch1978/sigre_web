package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class JobEjecucionResponse {
    private String job;
    private Integer anio;
    private Integer mes;
    private int registrosProcesados;
    private int registrosContabilizados;
}
