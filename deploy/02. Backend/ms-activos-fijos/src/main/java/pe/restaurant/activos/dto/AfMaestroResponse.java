package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfMaestroResponse {

    private Long id;
    private String codigo;
    private String nombre;
    private Long afSubClaseId;
    private Long afUbicacionId;
    private LocalDate fechaAdquisicion;
    private BigDecimal valorAdquisicion;
    private BigDecimal valorResidual;
    private Long proveedorId;
    private Integer unidadesProduccionTotales;
    private Integer unidadesProduccionPeriodo;
    private Long ordenCompraId;
    private Long ordenCompraLineaId;
    private String flagEstado;
}
