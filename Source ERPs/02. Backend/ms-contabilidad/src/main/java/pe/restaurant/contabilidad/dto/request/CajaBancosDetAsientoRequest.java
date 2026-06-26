package pe.restaurant.contabilidad.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
public class CajaBancosDetAsientoRequest {

    private Long id;

    private Integer item;

    private Long entidadContribuyenteId;

    private Long docTipoId;

    private String nroDoc;

    @NotNull(message = "El importe es obligatorio")
    private BigDecimal importe;

    private Long cntasPagarId;

    private Long cntasCobrarId;

    private Long solicitudGiroId;

    private Long liquidacionId;

    @NotNull(message = "El concepto financiero es obligatorio en cada detalle")
    private Long conceptoFinancieroId;

    private Long centrosCostoId;

    private Long monedaId;

    private Long sucursalRefId;

    private String glosa;
}
