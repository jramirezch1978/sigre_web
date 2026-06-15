package com.sigre.auth.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UsuarioEmpresaSyncResponse {

    private Long usuarioId;
    private String username;
    private String email;
    private Long empresaId;
    private String empresaCodigo;
    private String dbName;
    private Boolean activo;
    private String mensaje;
}
