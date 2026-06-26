package pe.restaurant.ventas.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrdenVentaRequest {

    @NotNull
    private Long sucursalId;

    private String nroOrdenVenta;

    private Long clienteId;
    private Long vendedorId;

    @NotNull
    private LocalDate fechaEmision;

    private Long monedaId;
    private Long docTipoId;
    private Long formaPagoId;
    private String observaciones;

    @Valid
    private List<OrdenVentaDetLineRequest> detalles;
}
