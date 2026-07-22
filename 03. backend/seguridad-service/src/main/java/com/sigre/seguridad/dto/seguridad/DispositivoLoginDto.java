package com.sigre.seguridad.dto.seguridad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import java.time.OffsetDateTime;

/** Fila del historial de inicios de sesión de un dispositivo, para /admin. */
@Getter
@Builder
@AllArgsConstructor
public class DispositivoLoginDto {
    private long id;
    private Long usuarioId;
    private String usuarioNombre;
    private OffsetDateTime fecLogin;
}
