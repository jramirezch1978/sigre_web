package pe.restaurant.contabilidad.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AsientoDetalleResponse {

    private Long id;
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
    private String flagDebeHaber;
    private BigDecimal importeSol;
    private BigDecimal importeDol;
    private Long bancoCtaId;
    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
