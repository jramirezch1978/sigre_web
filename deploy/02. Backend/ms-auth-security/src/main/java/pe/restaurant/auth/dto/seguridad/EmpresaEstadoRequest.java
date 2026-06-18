package pe.restaurant.auth.dto.seguridad;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class EmpresaEstadoRequest {

    @NotNull
    private Boolean activo;
}
