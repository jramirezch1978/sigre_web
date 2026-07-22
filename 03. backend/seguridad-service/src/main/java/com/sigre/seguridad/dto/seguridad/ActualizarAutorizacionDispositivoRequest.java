package com.sigre.seguridad.dto.seguridad;

import lombok.Getter;
import lombok.Setter;

/** PUT /api/auth/seguridad/admin/dispositivos/{id}/autorizacion. */
@Getter
@Setter
public class ActualizarAutorizacionDispositivoRequest {
    private boolean autorizado;
}
