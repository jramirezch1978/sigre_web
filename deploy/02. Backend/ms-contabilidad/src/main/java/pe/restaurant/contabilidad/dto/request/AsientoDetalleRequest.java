package pe.restaurant.contabilidad.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AsientoDetalleRequest {

    @NotNull(message = "El ID del plan contable es obligatorio")
    private Long planContableDetId;

    private Long centrosCostoId;

    private Long entidadContribuyenteId;

    private String glosaDetalle;

    private Long docTipoId;

    private String nroReferencia;

    private Long cntasPagarId;

    private Long cntasCobrarId;

    private Long solicitudGiroId;

    private Long afMaestroId;

    private Long cajaBancosId;

    private Long liquidacionId;

    @NotBlank(message = "El flag debe/haber es obligatorio")
    private String flagDebeHaber;

    @NotNull(message = "El importe en soles es obligatorio")
    private BigDecimal importeSol;

    @NotNull(message = "El importe en dólares es obligatorio")
    private BigDecimal importeDol;
}
