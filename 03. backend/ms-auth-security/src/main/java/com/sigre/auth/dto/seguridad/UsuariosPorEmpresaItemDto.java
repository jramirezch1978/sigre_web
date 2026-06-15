package com.sigre.auth.dto.seguridad;

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
public class UsuariosPorEmpresaItemDto {
    private Long empresaId;
    private String razonSocial;
    private long usuarios;
}
