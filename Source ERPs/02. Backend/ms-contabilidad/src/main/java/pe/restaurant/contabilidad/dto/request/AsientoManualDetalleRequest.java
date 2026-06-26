package pe.restaurant.contabilidad.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AsientoManualDetalleRequest {

    @NotNull(message = "La cuenta contable es obligatoria")
    private Long planContableDetId;

    private Long centrosCostoId;

    private Long entidadContribuyenteId;

    @NotBlank(message = "La glosa del detalle es obligatoria")
    private String glosaDetalle;

    private Long docTipoId;

    @Size(max = 25, message = "El número de referencia debe tener máximo 25 caracteres")
    private String nroReferencia;

    private Long cajaBancosId;

    private Long solicitudGiroId;

    private Long liquidacionId;

    private Long afMaestroId;

    private Long cntasPagarId;

    private Long cntasCobrarId;

    private Long bancoCtaId;

    @NotBlank(message = "El flag debe/haber es obligatorio")
    @Pattern(regexp = "^[DH]$", message = "El flag debe/haber debe ser D (Debe) o H (Haber)")
    private String flagDebeHaber;

    @NotNull(message = "El importe en soles es obligatorio")
    @DecimalMin(value = "0.0001", message = "El importe en soles debe ser mayor a cero")
    private BigDecimal importeSol;

    @NotNull(message = "El importe en dólares es obligatorio")
    @DecimalMin(value = "0", inclusive = true, message = "El importe en dólares no puede ser negativo")
    private BigDecimal importeDol;
}
