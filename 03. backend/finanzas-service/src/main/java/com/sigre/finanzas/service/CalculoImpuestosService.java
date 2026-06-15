package com.sigre.finanzas.service;

import com.sigre.finanzas.dto.request.CalcularImpuestosRequest;
import com.sigre.finanzas.dto.response.CalcularImpuestosResponse;

public interface CalculoImpuestosService {
    CalcularImpuestosResponse calcular(CalcularImpuestosRequest request);
}
