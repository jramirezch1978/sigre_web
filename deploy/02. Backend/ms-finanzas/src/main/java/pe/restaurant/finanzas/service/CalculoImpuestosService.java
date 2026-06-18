package pe.restaurant.finanzas.service;

import pe.restaurant.finanzas.dto.request.CalcularImpuestosRequest;
import pe.restaurant.finanzas.dto.response.CalcularImpuestosResponse;

public interface CalculoImpuestosService {
    CalcularImpuestosResponse calcular(CalcularImpuestosRequest request);
}
