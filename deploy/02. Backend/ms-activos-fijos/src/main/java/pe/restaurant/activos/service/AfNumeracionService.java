package pe.restaurant.activos.service;

import pe.restaurant.activos.dto.AfNumeracionConfigRequest;
import pe.restaurant.activos.dto.AfNumeracionConfigResponse;
import pe.restaurant.activos.dto.SiguienteCodigoResponse;

public interface AfNumeracionService {

    AfNumeracionConfigResponse obtenerConfig(String tipo);

    AfNumeracionConfigResponse actualizarConfig(String tipo, AfNumeracionConfigRequest request);

    SiguienteCodigoResponse generarSiguienteCodigo(String tipo);
}
