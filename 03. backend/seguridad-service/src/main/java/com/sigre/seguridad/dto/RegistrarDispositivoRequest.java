package com.sigre.seguridad.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

/** Alta (o re-consulta idempotente) de un dispositivo móvil — POST /api/auth/dispositivo/registrar. */
@Getter
@Setter
public class RegistrarDispositivoRequest {

    @NotBlank(message = "El identificador del dispositivo es requerido")
    @Size(max = 120, message = "Máximo 120 caracteres")
    private String deviceId;

    @Size(max = 50, message = "Máximo 50 caracteres")
    private String imei;

    @Size(max = 100, message = "Máximo 100 caracteres")
    private String fabricante;

    @Size(max = 100, message = "Máximo 100 caracteres")
    private String modelo;

    @Size(max = 200, message = "Máximo 200 caracteres")
    private String nombreDispositivo;

    @Size(max = 100, message = "Máximo 100 caracteres")
    private String software;
}
