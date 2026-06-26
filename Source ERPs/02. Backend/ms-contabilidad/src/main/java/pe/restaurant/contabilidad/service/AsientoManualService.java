package pe.restaurant.contabilidad.service;

import pe.restaurant.contabilidad.dto.request.AsientoManualRequest;
import pe.restaurant.contabilidad.entity.CntblAsiento;

public interface AsientoManualService {

    CntblAsiento crear(AsientoManualRequest request);

    CntblAsiento actualizar(Long id, AsientoManualRequest request);
}
