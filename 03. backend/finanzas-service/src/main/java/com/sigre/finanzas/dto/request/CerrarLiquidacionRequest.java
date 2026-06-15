package com.sigre.finanzas.dto.request;

import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CerrarLiquidacionRequest {

    @Size(max = 200, message = "La observación no puede exceder 200 caracteres")
    private String observacion;
}
