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

    @NotNull(message = "La fecha de baja es requerida")
    private LocalDate fechaBaja;

    @NotBlank(message = "El motivo es requerido")
    @Size(max = 30, message = "El motivo no puede exceder 30 caracteres")
    private String motivo;

    @DecimalMin(value = "0.00", message = "El valor de venta debe ser mayor o igual a 0")
    @Digits(integer = 14, fraction = 4, message = "El valor de venta debe tener máximo 14 enteros y 4 decimales")
    private BigDecimal valorVenta;

    @Size(max = 200, message = "El comprador no puede exceder 200 caracteres")
    private String comprador;

    @Size(max = 20, message = "El tipo de baja no puede exceder 20 caracteres")
    private String tipoBaja;

    @Size(max = 30, message = "El tipo de documento no puede exceder 30 caracteres")
    private String tipoDocumentoVenta;

    @Size(max = 30, message = "El número de documento no puede exceder 30 caracteres")
    private String numeroDocumento;

    @Size(max = 50, message = "El tipo de siniestro no puede exceder 50 caracteres")
    private String tipoSiniestro;

    @DecimalMin(value = "0.00", message = "El monto de indemnización debe ser mayor o igual a 0")
    private BigDecimal montoIndemnizacion;

    @Size(max = 50, message = "El motivo de obsolescencia no puede exceder 50 caracteres")
    private String motivoObsolescencia;

    private String descripcionDetalle;
}
