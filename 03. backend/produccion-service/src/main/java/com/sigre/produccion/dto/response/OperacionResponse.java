package com.sigre.produccion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OperacionResponse {

    private Long id;

    private Long ordenTrabajoId;
    private String ordenTrabajoCodigo;

    private Integer nroOperacion;
    private Long laborId;
    private Long ejecutorId;
    private Long entidadContribuyenteId;
    private Long centrosCostoId;
    private Long unidadMedidaId;
    private String descripcion;
    private Integer nroPersonas;
    private LocalDate fecInicioEstimado;
    private LocalDate fecInicio;
    private LocalDate fecFin;
    private BigDecimal diasParaInicio;
    private BigDecimal diasDuracionProy;
    private Integer diasHolgura;
    private BigDecimal cantidadProyectada;
    private BigDecimal cantidadReal;
    private BigDecimal costoUnitario;
    private BigDecimal costoProyectado;
    private String observacion;
    private String flagEstado;

    private List<OperacionDetResponse> detalles;

    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
