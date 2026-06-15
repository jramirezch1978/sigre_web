package com.sigre.auth.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EmpresaUsuarioDto {

    private Long empresaId;
    private String codigo;
    private String razonSocial;
    private String ruc;
    private String dbName;
}
