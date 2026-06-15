package com.sigre.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrdenCompraRecepcionResponse {

    private Long ordenCompraId;
    private String numeroOrdenCompra;
    private MovimientoDetalleResponse recepcion;
    private OrdenCompraSaldoPendienteResponse saldoPendiente;
}
