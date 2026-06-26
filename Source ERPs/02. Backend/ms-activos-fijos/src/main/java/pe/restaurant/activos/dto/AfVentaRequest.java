package pe.restaurant.activos.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfVentaRequest {

    @NotNull(message = "El ID del activo maestro es requerido")
    private Long afMaestroId;

    @NotNull(message = "El ID de la cuenta por cobrar (factura/boleta) es requerido")
    private Long cntasCobrarId;

    private Long docTipoId;

    @Size(max = 4, message = "La serie no puede exceder 4 caracteres")
    private String serieDoc;

    @Size(max = 10, message = "El número de documento no puede exceder 10 caracteres")
    private String nroDoc;

    @NotNull(message = "La fecha de baja es requerida")
    private LocalDate fechaBaja;

    @NotBlank(message = "El motivo es requerido")
    @Size(max = 3000, message = "El motivo no puede exceder 3000 caracteres")
    private String motivo;

    @DecimalMin(value = "0.00", message = "El valor de venta debe ser mayor o igual a 0")
    @Digits(integer = 14, fraction = 4, message = "El valor de venta debe tener máximo 14 enteros y 4 decimales")
    private BigDecimal valorVenta;

    @Size(max = 200, message = "El comprador no puede exceder 200 caracteres")
    private String comprador;
}
