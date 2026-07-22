package com.sigre.seguridad.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

/** Respuesta del alta/consulta de dispositivo: el nro de registro que el cliente debe reenviar en cada login. */
@Getter
@Builder
@AllArgsConstructor
public class DispositivoRegistradoResponse {
    private String nroRegistro;
    private boolean autorizado;
}
