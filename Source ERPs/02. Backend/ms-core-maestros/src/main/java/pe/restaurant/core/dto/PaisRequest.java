package pe.restaurant.core.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PaisRequest {

    @NotBlank
    @Size(max = 20)
    private String codigo;

    @NotBlank
    @Size(max = 150)
    private String nombre;

    private Long monedaId;

    @Size(max = 20)
    private String formatoFecha;

    @Size(max = 60)
    private String zonaHoraria;
}
