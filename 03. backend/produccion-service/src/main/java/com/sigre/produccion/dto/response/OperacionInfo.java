package com.sigre.produccion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OperacionInfo {
    private Long id;
    private Integer nroOperacion;
    private LaborInfo labor;
    private EjecutorInfo ejecutor;
    private EntidadContribuyenteInfo entidadContribuyente;
    private CentrosCostoInfo centrosCosto;
    private UnidadMedidaInfo unidadMedida;
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
    private List<OperacionDetalleInfo> detalles;
}
