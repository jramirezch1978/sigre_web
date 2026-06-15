package com.sigre.produccion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CaractDetResponse {

    private Long id;
    private String caracteristica;
    private String valor;
    private Long unidadMedidaId;
    private String unidadMedidaCodigo;
}
