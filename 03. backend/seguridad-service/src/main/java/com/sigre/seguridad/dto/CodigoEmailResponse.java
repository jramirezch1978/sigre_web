package com.sigre.seguridad.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CodigoEmailResponse {
    private int validezSegundos;
    private int reenvioSegundos;
    private String emailDestino;
}
