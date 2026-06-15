package com.sigre.comercializacion.dto.response;

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
public class FacturaSimplificadaResponse {

    private Long id;
    private Long sucursalId;
    private Long puntoVentaId;
    private Long clienteId;
    private Long docTipoId;
    private String serie;
    private String numero;
    private LocalDate fechaEmision;
    private Long monedaId;
    private BigDecimal subtotal;
    private BigDecimal impuesto;
    private BigDecimal total;
    private Long cntasCobrarId;
    private String flagEstado;
    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
    private List<FacturaSimplDetResponse> items;
    private List<FacturaSimplPagoResponse> pagos;
}
