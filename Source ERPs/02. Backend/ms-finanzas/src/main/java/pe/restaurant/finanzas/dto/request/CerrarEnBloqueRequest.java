package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CerrarEnBloqueRequest {

    @NotEmpty(message = "La lista de IDs es requerida")
    private List<Long> ids;

    @Size(max = 200, message = "La observación no puede exceder 200 caracteres")
    private String observacion;
}
