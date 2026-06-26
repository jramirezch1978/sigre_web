package pe.restaurant.activos.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class AfAccesorioRequest {

    @NotNull
    private Long afMaestroId;

    @NotBlank
    @Size(max = 200)
    private String descripcion;

    private BigDecimal costo;
    private LocalDate fechaInstalacion;
}
