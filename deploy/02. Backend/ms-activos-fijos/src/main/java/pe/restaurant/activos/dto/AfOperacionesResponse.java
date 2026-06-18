package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfOperacionesResponse {

    private Long id;
    private Long afMaestroId;
    private String tipo;
    private LocalDate fechaProgramada;
    private LocalDate fechaEjecucion;
    private BigDecimal costo;
    private String proveedorServicio;
}
