package com.sigre.auth.dto.seguridad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EmpresaAdminDto {
    private Long id;
    private String codigo;
    private String ruc;
    private String razonSocial;
    private String nombreComercial;
    private String direccionFiscal;
    private String correoContacto;
    private String telefonoContacto;
    private String dbName;
    private Boolean activo;
}
