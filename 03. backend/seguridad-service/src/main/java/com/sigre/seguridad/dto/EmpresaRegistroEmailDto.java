package com.sigre.seguridad.dto;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class EmpresaRegistroEmailDto {

    String codigo;
    String ruc;
    String razonSocial;
    String nombreComercial;
    String sigla;
    String direccionFiscal;
    String departamento;
    String provincia;
    String distrito;
    String ubigeo;
    String representanteLegal;
    String dniRepresentanteLegal;
    String correoContacto;
    String telefonoContacto;
    String dbHost;
    Integer dbPort;
    String dbName;
    String dbUser;
    String fechaRegistro;
}
