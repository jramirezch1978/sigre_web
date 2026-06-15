package com.sigre.produccion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecetaResponse {

    private Long id;
    private Long articuloProducidoId;
    private String articuloCodigo;
    private String articuloDescripcion;
    private String nroReceta;
    private String nombre;
    private Integer version;
    private String flagTipoReceta;
    private BigDecimal rendimientoEsperado;
    private BigDecimal porcentajeMerma;
    private BigDecimal costoManoObra;
    private BigDecimal costoIndirecto;
    private BigDecimal costoTotalEstimado;
    private String flagEstado;
    private List<RecetaLaborResponse> labores;
    private List<RecetaConsumibleResponse> consumibles;
    private FichaTecnicaResponse fichaTecnica;
    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
