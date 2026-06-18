package pe.restaurant.activos.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class AfMaestroCcDistribResponse {
    private Long id;
    private Long afMaestroId;
    private Long centroCostoId;
    private BigDecimal porcentaje;
}
