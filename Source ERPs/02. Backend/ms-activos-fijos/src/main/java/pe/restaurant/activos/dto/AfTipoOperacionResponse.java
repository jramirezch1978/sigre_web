package pe.restaurant.activos.dto;

import lombok.Data;

@Data
public class AfTipoOperacionResponse {
    private Long id;
    private String codigo;
    private String descripcion;
    private String naturaleza;
    private String tipoCalculo;
    private Long cuentaContableId;
    private Long centroCostoId;
    private Boolean afectaContabilidad;
    private String metodoCalculo;
    private String observaciones;
    private String flagEstado;
}
