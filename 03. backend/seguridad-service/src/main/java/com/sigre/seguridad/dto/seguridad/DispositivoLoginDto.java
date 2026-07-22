package com.sigre.seguridad.dto.seguridad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import java.time.OffsetDateTime;

/** Fila de sesión (SEG_LOGIN_DEVICE) de un dispositivo, para /admin. */
@Getter
@Builder
@AllArgsConstructor
public class DispositivoLoginDto {
    private String nroRegistro;
    private Long usuarioId;
    private String usuarioNombre;
    private String imei;
    private String software;
    private OffsetDateTime fecLogin;
    private OffsetDateTime fecLogout;
    private OffsetDateTime fecRegistro;
}
