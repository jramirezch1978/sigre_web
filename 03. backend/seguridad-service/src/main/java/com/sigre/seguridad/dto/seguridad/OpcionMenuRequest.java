package com.sigre.seguridad.dto.seguridad;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OpcionMenuRequest {

    @NotNull
    private Long moduloId;

    @NotBlank
    @Size(max = 80)
    private String codigo;

    @NotBlank
    @Size(max = 160)
    private String nombre;

    @Size(max = 250)
    private String rutaFrontend;

    /** Ruta RELATIVA del componente Angular. NULL/vacio => opcion en construccion. */
    @Size(max = 250)
    private String pathUrl;

    private Long opcionPadreId;

    private Integer orden = 0;

    private Boolean activo = Boolean.TRUE;
}
