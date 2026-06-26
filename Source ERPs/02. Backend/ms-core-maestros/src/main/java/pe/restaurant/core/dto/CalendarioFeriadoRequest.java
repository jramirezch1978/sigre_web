package pe.restaurant.core.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CalendarioFeriadoRequest {

    @NotNull
    private LocalDate fecha;

    @NotBlank
    @Size(max = 220)
    private String descripcion;

    private Long sucursalId;

    private String flagEstado = "1";
}
