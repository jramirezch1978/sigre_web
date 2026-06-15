package com.sigre.seguridad.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Actualización del usuario/clave del rol PostgreSQL del tenant y de {@code master.empresa}.
 * Debe enviarse al menos uno de: {@code codigo}, {@code ruc}, {@code dbName}.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ActualizarCredencialesBdRequest {

    @Size(max = 20)
    private String codigo;

    @Size(max = 20)
    private String ruc;

    @Size(max = 120)
    private String dbName;

    @NotBlank(message = "El usuario de la base de datos es obligatorio")
    @Size(max = 120)
    private String dbUser;

    @NotBlank(message = "La contraseña de la base de datos es obligatoria")
    @Size(max = 256)
    private String dbPassword;
}
