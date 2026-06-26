package pe.restaurant.activos.dto;

import lombok.Data;

@Data
public class AfNumeracionConfigResponse {
    private Long id;
    private String tipo;
    private String prefijo;
    private Long secuenciaActual;
    private Integer longitudNumero;
    private String flagEstado;
}
