package com.sigre.finanzas.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ConciliacionDetRequest {

    private Long cajaBancosId;
    private Boolean conciliado = false;
    private String observacion;
}
