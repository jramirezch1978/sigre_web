package com.sigre.seguridad.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConsultaRucDto {

    private String ruc;
    private String razonSocial;
    private String nombreComercial;
    private String direccionFiscal;
    private String estado;
    private String condicion;
    private String ubigeo;
    private String departamento;
    private String provincia;
    private String distrito;
}
