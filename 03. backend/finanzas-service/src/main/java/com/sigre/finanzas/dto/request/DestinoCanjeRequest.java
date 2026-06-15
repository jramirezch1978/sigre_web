package com.sigre.finanzas.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DestinoCanjeRequest {
    
    @NotNull(message = "El ID del tipo de documento es obligatorio")
    private Long docTipoId;
    
    @Size(max = 10, message = "La serie no puede exceder 10 caracteres")
    private String serie;
    
    @Size(max = 20, message = "El número no puede exceder 20 caracteres")
    private String numero;
    
    @NotNull(message = "La fecha de emisión es obligatoria")
    private LocalDate fechaEmision;
    
    private LocalDate fechaVencimiento;
    
    private Long monedaId;
    
    @NotNull(message = "El total es obligatorio")
    @Positive(message = "El total debe ser mayor a cero")
    private BigDecimal total;
}
