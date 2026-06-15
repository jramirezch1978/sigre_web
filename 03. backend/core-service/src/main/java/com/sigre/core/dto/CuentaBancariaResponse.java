package com.sigre.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CuentaBancariaResponse {
    private Long id;
    private String codBanco;
    private String numeroCuenta;
    private String cci;
    private Long monedaId;
    private String tipoCuenta;
}
