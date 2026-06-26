package pe.restaurant.compras.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class OrdenCompraMotivoRequest {

    @NotBlank
    private String motivo;
}
