package com.sigre.seguridad.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

/** Respuesta del alta de dispositivo: nro de sesión (SEG_LOGIN_DEVICE) que el cliente reenvía en cada login. */
@Getter
@Builder
@AllArgsConstructor
public class DispositivoRegistradoResponse {
    private String nroRegistro;
    private boolean autorizado;
}
