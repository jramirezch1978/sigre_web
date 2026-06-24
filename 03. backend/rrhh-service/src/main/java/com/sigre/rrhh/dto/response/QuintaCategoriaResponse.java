package com.sigre.rrhh.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO de respuesta para quinta categoría (esquema SIGRE).
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuintaCategoriaResponse {

    private Long id;
    private Long trabajadorId;
    private String trabajadorNombres;
    private String fecProceso;
    private Long tipoPlanillaId;
    private String tipoPlanillaCodigo;
    private BigDecimal remProyectable;
    private BigDecimal remImprecisa;
    private BigDecimal remRetencion;
    private BigDecimal remGratif;
    private BigDecimal sueldo;
    private BigDecimal gratifProyect;
    private BigDecimal remExterna;
    private Short nroDias;
    private String flagAutomatico;
    private String flagReplicacion;
    private Long createdBy;
    private String fecCreacion;
    private Long updatedBy;
    private String fecModificacion;
}
