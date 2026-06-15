package com.sigre.produccion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LaborEjecutorResponse {

    private Long id;
    private Long laborId;
    private String laborNombre;
    private Long ejecutorId;
    private String ejecutorNombre;
    private Long unidadMedidaAltId;
    private String unidadMedidaAltNombre;
    private Long monedaId;
    private String monedaNombre;
    private BigDecimal factorConversion;
    private Integer nroPersonas;
    private BigDecimal ratioEstimado;
    private BigDecimal costoUnitario;
    private String flagCostoFijo;
    private String flagEstado;
    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
