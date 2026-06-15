package com.sigre.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AlmacenUsuarioResponse {

    private Long id;
    private Long almacenId;
    private Long usuarioId;
    private UsuarioResumenDto usuario;
    private String flagEstado;
    private Long createdBy;
    private UsuarioResumenDto createdByUsuario;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private UsuarioResumenDto updatedByUsuario;
    private OffsetDateTime fecModificacion;
}
