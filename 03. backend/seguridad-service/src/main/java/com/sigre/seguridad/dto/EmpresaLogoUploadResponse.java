package com.sigre.seguridad.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EmpresaLogoUploadResponse {
    private Long empresaId;
    private String codigo;
    private Long logoSizeBytes;
    private String mensaje;
}
