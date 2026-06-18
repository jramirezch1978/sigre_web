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
public class ContactoRequest {
    @NotBlank
    @Size(max = 200)
    private String nombre;

    @Size(max = 100)
    private String cargo;

    @Size(max = 30)
    private String telefono;

    @Size(max = 120)
    private String email;
}
