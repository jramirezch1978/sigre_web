package pe.restaurant.contabilidad.service;

import pe.restaurant.contabilidad.dto.request.GenerarAsientoRequest;
import pe.restaurant.contabilidad.dto.request.ImportarPreasientoRequest;
import pe.restaurant.contabilidad.dto.response.GenerarPreasientoResponse;
import pe.restaurant.contabilidad.dto.response.ImportarPreasientoResponse;
import pe.restaurant.contabilidad.enums.TipoOperacionContable;

public interface GenerarPreasientoService {

    GenerarPreasientoResponse generarPreasiento(TipoOperacionContable tipoOperacion,
                                                 GenerarAsientoRequest request);

    ImportarPreasientoResponse importarPreasientos(ImportarPreasientoRequest request);
}
