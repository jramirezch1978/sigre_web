package com.sigre.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CajaBancosDetResponse {

    private Long id;
    private Long cajaBancosId;
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
    private String flagCxp;
    private Long sucursalRefId;
    private Long monedaId;
    private Long centrosCostoId;
    private Long codigoFlujoCajaId;
    private Long bancoCntaProvId;
    private String flagEstado;
    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
