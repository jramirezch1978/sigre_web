package pe.restaurant.almacen.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
public class InventarioConteoRequest {
    @NotNull
    private Long almacenId;
    @NotNull
    private Long articuloId;
    @NotNull
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
}
