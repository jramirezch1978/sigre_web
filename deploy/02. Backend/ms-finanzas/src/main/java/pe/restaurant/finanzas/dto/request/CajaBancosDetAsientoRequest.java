package pe.restaurant.finanzas.dto.request;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@Builder
public class CajaBancosDetAsientoRequest {

    private Long id;
    private Integer item;
    private Long entidadContribuyenteId;
    private Long docTipoId;
    private String nroDoc;
    private BigDecimal importe;
    private Long cntasPagarId;
    private Long cntasCobrarId;
    private Long solicitudGiroId;
    private Long liquidacionId;
    private Long conceptoFinancieroId;
    private Long centrosCostoId;
    private Long monedaId;
    private Long sucursalRefId;
    private String glosa;
}
