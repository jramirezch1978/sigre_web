package com.sigre.seguridad.dto.seguridad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SesionHistogramaItemDto {
    /** ISO fecha (yyyy-MM-dd). */
    private String dia;
    private Long empresaId;
    private String empresaNombre;
    private long sesiones;
}
