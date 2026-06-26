package pe.restaurant.auth.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * Solicitud de eliminación de empresa. Se puede enviar uno, dos o los tres parámetros.
 * Si se envían varios, TODOS deben coincidir con el mismo registro.
 */
@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class DeleteEmpresaRequest {

    @Size(max = 20)
    private String codigo;

    @Size(max = 20)
    private String ruc;

    @Size(max = 120)
    private String dbName;
}
