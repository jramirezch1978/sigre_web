package com.sigre.seguridad.dto.seguridad;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class UbigeoResumenDto {

    String departamentoNombre;
    String provinciaNombre;
    String distritoNombre;
    String distritoCodigo;
}
