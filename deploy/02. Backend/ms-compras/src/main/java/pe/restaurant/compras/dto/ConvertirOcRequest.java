package pe.restaurant.compras.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConvertirOcRequest {
    @NotNull
    private LocalDate fechaEmision;
    private LocalDate fechaEntrega;
    private Long formaPagoId;
    private String observaciones;
}
