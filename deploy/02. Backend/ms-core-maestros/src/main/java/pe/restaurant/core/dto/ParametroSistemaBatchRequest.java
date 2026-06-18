package pe.restaurant.core.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ParametroSistemaBatchRequest {

    @NotEmpty(message = "La lista de parámetros no puede estar vacía")
    @Valid
    private List<ParametroSistemaBatchItem> items;
}
