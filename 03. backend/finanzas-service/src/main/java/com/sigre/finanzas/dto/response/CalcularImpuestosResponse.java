package com.sigre.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CalcularImpuestosResponse {

    private String pais;

    private List<ItemCalculoResponse> items;

    private ConsolidadoResponse consolidado;

    private DetraccionCalculadaResponse detraccion;
}
