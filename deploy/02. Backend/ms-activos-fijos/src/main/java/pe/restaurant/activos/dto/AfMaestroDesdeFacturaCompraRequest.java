package pe.restaurant.activos.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class AfMaestroDesdeFacturaCompraRequest {

    @NotNull
    private Long ordenCompraId;

    @NotNull
    private Long ordenCompraLineaId;

    @NotBlank
    private String facturaSerie;

    @NotBlank
    private String facturaNumero;

    @NotNull
    private LocalDate facturaFecha;

    @NotBlank
    private String codigo;

    @NotNull
    private Long afSubClaseId;

    private Long afUbicacionId;

    private String nombre;

    private LocalDate fechaAdquisicion;

    @NotNull
    @DecimalMin("0.0001")
    private BigDecimal valorAdquisicion;

    private BigDecimal valorResidual;

    private Long proveedorId;
}
