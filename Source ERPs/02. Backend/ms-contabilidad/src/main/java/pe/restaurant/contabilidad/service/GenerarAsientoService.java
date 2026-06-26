package pe.restaurant.contabilidad.service;

import pe.restaurant.contabilidad.dto.request.*;
import pe.restaurant.contabilidad.dto.response.GenerarAsientoResponse;
import pe.restaurant.contabilidad.enums.TipoOperacionContable;

public interface GenerarAsientoService {

    GenerarAsientoResponse generarAsientoCajaBancos(TipoOperacionContable tipoOperacion,
                                                     CajaBancosAsientoRequest request);

    GenerarAsientoResponse generarAsientoCntasPagar(TipoOperacionContable tipoOperacion,
                                                     CntasPagarAsientoRequest request);

    GenerarAsientoResponse generarAsientoCntasCobrar(TipoOperacionContable tipoOperacion,
                                                      CntasCobrarAsientoRequest request);

    GenerarAsientoResponse generarAsientoLiquidacion(TipoOperacionContable tipoOperacion,
                                                      LiquidacionAsientoRequest request);
}
