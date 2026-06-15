package com.sigre.finanzas.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BancoRequest {
    
    @NotBlank(message = "El código del banco es obligatorio")
    @Size(max = 3, message = "El código del banco no puede exceder 3 caracteres")
    private String codBanco;
    
    @NotBlank(message = "El nombre del banco es obligatorio")
    @Size(max = 120, message = "El nombre del banco no puede exceder 120 caracteres")
    private String nomBanco;
    
    @Size(max = 8, message = "El proveedor no puede exceder 8 caracteres")
    private String proveedor;
    
    @Size(max = 2, message = "El código RTPS no puede exceder 2 caracteres")
    private String codBancoRtps;
    
    @Size(max = 200, message = "La dirección no puede exceder 200 caracteres")
    private String direccion;
    
    @Size(max = 20, message = "El código SWIFT no puede exceder 20 caracteres")
    private String swift;
    
    @Size(max = 2, message = "El código SUNAT no puede exceder 2 caracteres")
    private String codBancoSunat;
}
