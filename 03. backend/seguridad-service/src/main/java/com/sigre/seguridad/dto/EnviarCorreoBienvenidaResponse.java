package com.sigre.seguridad.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class EnviarCorreoBienvenidaResponse {

    private Long empresaId;
    private String codigo;
    private String razonSocial;
    private String correoContacto;
    private String mensaje;
}
