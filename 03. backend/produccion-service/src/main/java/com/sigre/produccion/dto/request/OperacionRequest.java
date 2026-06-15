package com.sigre.produccion.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OperacionRequest {

    @NotNull(message = "La orden de trabajo es requerida")
    private Long ordenTrabajoId;

    @NotNull(message = "El número de operación es requerido")
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

    @Digits(integer = 5, fraction = 2)
    private BigDecimal diasParaInicio;

    @Digits(integer = 5, fraction = 2)
    private BigDecimal diasDuracionProy;

    private Integer diasHolgura;

    @Digits(integer = 18, fraction = 4)
    private BigDecimal cantidadProyectada;

    @Digits(integer = 18, fraction = 4)
    private BigDecimal cantidadReal;

    @Digits(integer = 18, fraction = 4)
    private BigDecimal costoUnitario;

    @Digits(integer = 18, fraction = 4)
    private BigDecimal costoProyectado;

    private String observacion;

    @Valid
    private List<OperacionDetRequest> detalles;
}
