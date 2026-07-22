package com.sigre.seguridad.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

/** Alta del maestro + sesión de dispositivo móvil — POST /api/auth/dispositivo/registrar. */
@Getter
@Setter
public class RegistrarDispositivoRequest {

    @NotBlank(message = "El identificador del dispositivo es requerido")
    @Size(max = 200, message = "Máximo 200 caracteres")
    private String deviceId;

    @Size(max = 200, message = "Máximo 200 caracteres")
    private String imei;

    @Size(max = 200, message = "Máximo 200 caracteres")
    private String fabricante;

    @Size(max = 200, message = "Máximo 200 caracteres")
    private String modelo;

    @Size(max = 200, message = "Máximo 200 caracteres")
    private String nombreDispositivo;

    @Size(max = 200, message = "Máximo 200 caracteres")
    private String software;

    @Size(max = 64, message = "Máximo 64 caracteres")
    private String ipPublica;

    @Size(max = 64, message = "Máximo 64 caracteres")
    private String ipPrivada;
}
