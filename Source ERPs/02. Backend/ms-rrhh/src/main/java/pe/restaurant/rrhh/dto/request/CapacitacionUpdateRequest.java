package pe.restaurant.rrhh.dto.request;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class CapacitacionUpdateRequest {
    private String nombre;
    private String descripcion;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private Integer horas;
    private String proveedor;
    private BigDecimal costo;
    private String flagEstado;
}
