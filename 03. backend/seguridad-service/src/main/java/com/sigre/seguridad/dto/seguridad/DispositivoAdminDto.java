package com.sigre.seguridad.dto.seguridad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import java.time.OffsetDateTime;

/** Fila del listado de dispositivos móviles en /admin. */
@Getter
@Builder
@AllArgsConstructor
public class DispositivoAdminDto {
    private long id;
    private String deviceId;
    private String nroRegistro;
    private String imei;
    private String fabricante;
    private String modelo;
    private String nombreDispositivo;
    private String software;
    private boolean autorizado;
    private Long usuarioId;
    private String usuarioNombre;
    private OffsetDateTime fecRegistro;
    private OffsetDateTime fecUltimoLogin;
}
