package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ContactoResponse {
    private Long id;
    private String nombre;
    private String cargo;
    private String telefono;
    private String email;
}
