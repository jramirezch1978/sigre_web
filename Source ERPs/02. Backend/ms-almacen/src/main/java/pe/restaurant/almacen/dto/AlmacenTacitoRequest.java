package pe.restaurant.almacen.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AlmacenTacitoRequest {

    @NotBlank
    @Size(max = 20)
    private String codClase;

    @NotNull
    private Long sucursalId;

    @NotNull
    private Long almacenId;
}
