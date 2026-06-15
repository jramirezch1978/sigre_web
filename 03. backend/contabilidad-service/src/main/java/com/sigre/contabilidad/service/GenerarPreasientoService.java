package com.sigre.contabilidad.service;

import com.sigre.contabilidad.dto.request.GenerarAsientoRequest;
import com.sigre.contabilidad.dto.request.ImportarPreasientoRequest;
import com.sigre.contabilidad.dto.response.GenerarPreasientoResponse;
import com.sigre.contabilidad.dto.response.ImportarPreasientoResponse;
import com.sigre.contabilidad.enums.TipoOperacionContable;

public interface GenerarPreasientoService {

    GenerarPreasientoResponse generarPreasiento(TipoOperacionContable tipoOperacion,
                                                 GenerarAsientoRequest request);

    ImportarPreasientoResponse importarPreasientos(ImportarPreasientoRequest request);
}
