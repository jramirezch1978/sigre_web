package pe.restaurant.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InventarioConteoResponse {
    private Long id;
    private Long almacenId;
    private Long articuloId;
    private LocalDate fechaConteo;
    private Integer nroConteo;
    private BigDecimal saldoSistema;
    private BigDecimal cantidadConteo1;
    private String auditorConteo1;
    private String nroFichaConteo1;
    private BigDecimal cantidadConteo2;
    private String auditorConteo2;
    private String nroFichaConteo2;
    private BigDecimal costoUnitario;
    private BigDecimal diferencia;
    private Long valeMovAjusteId;
    private Long lotePalletId;
    private Long ubicacionId;
    private Long usuarioId;
    private String flagEstado;
}
