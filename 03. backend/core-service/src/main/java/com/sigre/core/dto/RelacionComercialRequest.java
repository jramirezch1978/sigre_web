package com.sigre.core.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RelacionComercialRequest {
    @NotBlank
    @Size(max = 300)
    private String razonSocial;

    @Size(max = 300)
    private String nombreComercial;

    @NotNull
    private Long tipoDocIdentidadId;

    @NotBlank
    @Size(max = 20)
    private String nroDocumento;

    @Size(max = 300)
    private String direccion;

    @Size(max = 30)
    private String telefono;

    @Size(max = 120)
    private String email;

    private Boolean esProveedor = false;
    private Boolean esCliente = false;
    private Long tipoEntidadContribuyenteId;
    private String flagEstado = "1";
}
