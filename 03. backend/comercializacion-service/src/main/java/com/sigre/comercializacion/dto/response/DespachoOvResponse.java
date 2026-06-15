package com.sigre.comercializacion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import com.sigre.comercializacion.client.dto.MovimientoDetalleResponse;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DespachoOvResponse {

    private Long ordenVentaId;
    private String nroOrdenVenta;
    private MovimientoDetalleResponse movimiento;
}
