package com.sigre.seguridad.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecreateEmpresaResponse {
    private Long empresaId;
    private String codigo;
    private String ruc;
    private String dbName;
    private String mensaje;
}
