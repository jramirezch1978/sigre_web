package com.sigre.seguridad.dto.seguridad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import java.time.OffsetDateTime;

/** Fila del listado de dispositivos móviles en /admin (maestro DEVICE_MOBILE). */
@Getter
@Builder
@AllArgsConstructor
public class DispositivoAdminDto {
    private long id;
    private String deviceId;
    /** Última sesión emitida (informativo); el nro real vive en dispositivo_login. */
    private String ultimoNroRegistro;
    private String fabricante;
    private String modelo;
    private String nombreDispositivo;
    private String ipPublica;
    private String ipPrivada;
    private boolean autorizado;
    private Long usuarioId;
    private String usuarioNombre;
    private OffsetDateTime fecRegistro;
    private OffsetDateTime fecUltimoLogin;
}
