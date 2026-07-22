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

    /** Solo IPv4 (ej. 192.168.1.10). Máx. 15 caracteres. */
    @Size(max = 15, message = "IP pública IPv4 inválida (máx. 15)")
    private String ipPublica;

    /** Solo IPv4 (ej. 10.0.0.5). Máx. 15 caracteres. */
    @Size(max = 15, message = "IP privada IPv4 inválida (máx. 15)")
    private String ipPrivada;
}
