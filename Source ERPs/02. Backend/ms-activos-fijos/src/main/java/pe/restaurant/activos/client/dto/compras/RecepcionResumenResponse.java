package pe.restaurant.activos.client.dto.compras;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class RecepcionResumenResponse {
    private Long id;
    private String nroVale;
    private LocalDate fecha;
    private String flagEstado;
    private Long almacenId;
    private BigDecimal totalCantidad;
}
