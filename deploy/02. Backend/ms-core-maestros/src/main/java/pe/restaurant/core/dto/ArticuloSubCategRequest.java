package pe.restaurant.core.dto;

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
public class ArticuloSubCategRequest {

    @NotBlank
    @Size(max = 10)
    private String codSubCat;

    @NotBlank
    @Size(max = 200)
    private String descSubcateg;

    @NotNull
    private Long articuloCategId;
}
