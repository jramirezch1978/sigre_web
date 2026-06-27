package com.sigre.seguridad.dto.seguridad;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

public class GrupoUsuarioRequest {

    @Getter
    @Setter
    @NotBlank
    @Size(max = 80)
    private String codigo;

    @Getter
    @Setter
    @NotBlank
    @Size(max = 220)
    private String descripcion;

    @Getter
    @Setter
    private Boolean activo = Boolean.TRUE;

    /** Miembros (ids de usuario) que se crean junto con el grupo. Obligatorio al crear. */
    @Getter
    @Setter
    private List<Long> miembrosIds = new ArrayList<>();
}
