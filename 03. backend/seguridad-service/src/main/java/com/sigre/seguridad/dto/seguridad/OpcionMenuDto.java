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
public class OpcionMenuDto {
    private Long id;
    private Long moduloId;
    private String codigo;
    private String nombre;
    private String rutaFrontend;
    /** Ruta RELATIVA del componente/pagina Angular a cargar. NULL => opcion en construccion. */
    private String pathUrl;
    private Long opcionPadreId;
    private Integer orden;
    private Boolean activo;
}
