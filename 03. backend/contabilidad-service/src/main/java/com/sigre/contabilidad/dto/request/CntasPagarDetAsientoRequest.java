package com.sigre.contabilidad.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class CntasPagarDetAsientoRequest {

    private Long id;

    private Integer item;

    @NotNull(message = "El concepto financiero es obligatorio en cada detalle")
    private Long conceptoFinancieroId;

    private String descripcion;

    private Long articuloId;

    private BigDecimal cantidad;

    private BigDecimal precioUnitario;

    @NotNull(message = "El monto es obligatorio")
    private BigDecimal monto;

    private Long centrosCostoId;

    private List<DetImpuestoAsientoRequest> impuestos;

    private Long ordenCompraDetId;

    private Long ordenServicioDetId;

    private Long valeMovDetId;

    private LocalDate fechaMov;

    private String tipoMov;

    private String referencia;

    private String glosa;
}
