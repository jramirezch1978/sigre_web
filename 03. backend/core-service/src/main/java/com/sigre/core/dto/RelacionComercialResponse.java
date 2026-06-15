package com.sigre.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RelacionComercialResponse {
    private Long id;
    private String razonSocial;
    private String nombreComercial;
    private Long tipoDocIdentidadId;
    private String nroDocumento;
    private String direccion;
    private String telefono;
    private String email;
    private Boolean esProveedor;
    private Boolean esCliente;
    private Long tipoEntidadContribuyenteId;
    private String flagEstado;
}
