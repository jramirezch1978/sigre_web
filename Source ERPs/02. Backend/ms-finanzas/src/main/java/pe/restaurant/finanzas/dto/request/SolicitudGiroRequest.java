package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SolicitudGiroRequest {

    @NotNull(message = "La sucursal es obligatoria")
    private Long sucursalId;

    private Long solicitanteId;

    @NotNull(message = "La fecha es obligatoria")
    private LocalDate fecha;

    @NotNull(message = "El monto es obligatorio")
    @Positive(message = "El monto debe ser mayor a cero")
    private BigDecimal monto;

    private String motivo;

    /**
     * O = Orden de Giro, F = Fondo Fijo. Si es null el servicio usa O.
     */
    @Pattern(regexp = "O|F", message = "tipoSolicitud debe ser O o F")
    private String tipoSolicitud;

    private Long centrosCostoId;

    @NotNull(message = "La moneda es obligatoria")
    private Long monedaId;

    @NotNull(message = "La forma de pago es obligatoria")
    private Long formaPagoId;
}
