package com.sigre.auth.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import jakarta.validation.constraints.Email;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SeleccionEmpresaRequest {

    @NotNull(message = "El ID de empresa es requerido")
    @Positive(message = "ID de empresa debe ser positivo")
    private Long empresaId;

    @Size(max = 64)
    @Pattern(regexp = "^[0-9.:a-fA-F]*$", message = "Formato de IP no válido")
    private String ipAddress;

    @Size(max = 64)
    @Pattern(regexp = "^[0-9.:a-fA-F]*$", message = "Formato de IP no válido")
    private String ipPrivada;

    @Size(max = 500)
    private String browser;

    @Size(max = 120)
    @Pattern(regexp = "^[a-zA-Z0-9 /._\\-()]*$", message = "Formato de SO no válido")
    private String sistemaOperativo;

    @NotNull(message = "La sucursal es requerida")
    @Positive(message = "ID de sucursal debe ser positivo")
    private Long sucursalId;

    /**
     * Opcional: con contraseña permite llamar sin {@code Authorization} (misma verificación que {@code /login}).
     */
    @Email(message = "Correo no válido")
    @Size(max = 150)
    private String email;

    /** Contraseña cifrada como en {@link LoginRequest}; obligatoria si no hay Bearer temporal. */
    private String password;

    @Size(max = 64, message = "Hash de verificación muy largo")
    private String passwordHash;
}
