package com.sigre.produccion.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OtAdminUderRequest {

    @NotNull(message = "El usuario es requerido")
    @Positive(message = "El usuario debe ser un valor positivo")
    private Long usuarioId;
}
