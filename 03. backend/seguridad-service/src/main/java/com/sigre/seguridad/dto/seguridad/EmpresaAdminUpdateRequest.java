package com.sigre.seguridad.dto.seguridad;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class EmpresaAdminUpdateRequest {

    @NotBlank
    @Size(max = 200)
    private String razonSocial;

    @Size(max = 200)
    private String nombreComercial;

    @Size(max = 300)
    private String direccionFiscal;

    @Size(max = 200)
    private String representanteLegal;

    @Size(max = 20)
    private String dniRepresentanteLegal;

    @Size(max = 150)
    private String correoContacto;

    @Size(max = 30)
    private String telefonoContacto;
}
