package pe.restaurant.activos.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class AfAccesorioResponse {
    private Long id;
    private Long afMaestroId;
    private String descripcion;
    private BigDecimal costo;
    private LocalDate fechaInstalacion;
    private String flagEstado;
}
