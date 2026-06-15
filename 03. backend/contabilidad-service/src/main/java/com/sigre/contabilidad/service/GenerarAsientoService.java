package com.sigre.contabilidad.service;

import com.sigre.contabilidad.dto.request.*;
import com.sigre.contabilidad.dto.response.GenerarAsientoResponse;
import com.sigre.contabilidad.enums.TipoOperacionContable;

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
