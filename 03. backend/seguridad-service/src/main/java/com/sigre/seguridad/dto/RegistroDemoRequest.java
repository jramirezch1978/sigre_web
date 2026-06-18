package com.sigre.seguridad.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class RegistroDemoRequest {

    @Valid
    @NotNull
    private EmpresaDemo empresa;

    @Valid
    @NotNull
    private UsuarioDemo adminUser;

    private List<@Valid UsuarioDemo> usuariosAdicionales;

    @Getter
    @Setter
    public static class EmpresaDemo {
        @NotBlank
        @Size(min = 11, max = 11)
        private String ruc;

        @NotBlank
        @Size(max = 200)
        private String razonSocial;

        @Size(max = 200)
        private String nombreComercial;

        @Size(max = 300)
        private String direccionFiscal;

        @NotBlank
        private String correoContacto;

        private String telefonoContacto;
    }

    @Getter
    @Setter
    public static class UsuarioDemo {
        @NotBlank
        @Size(max = 80)
        private String username;

        @NotBlank
        private String email;

        @NotBlank
        @Size(min = 6)
        private String password;

        @NotBlank
        @Size(max = 120)
        private String nombres;

        @Size(max = 120)
        private String apellidos;
    }
}
