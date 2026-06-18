package com.sigre.seguridad.dto.seguridad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UbigeoLookupDto {

    private String ubigeo;
    private Long departamentoId;
    private String departamentoNombre;
    private Long provinciaId;
    private String provinciaNombre;
    private Long distritoId;
    private String distritoNombre;
}
